import 'dart:convert';

import 'package:doan/common/UriAPI.dart';
import 'package:doan/models/Comment.dart';
import 'package:doan/models/Story.dart';
import 'package:doan/screens/chap_screen.dart';
import 'package:doan/services/commnet_service.dart';
import 'package:doan/services/story_service.dart';
import 'package:doan/widgets/comment_section.dart';
import 'package:doan/widgets/story_card.dart';
import 'package:doan/widgets/story_carousel.dart';
import 'package:flutter/material.dart';

import 'base_screen.dart';

class DetailStoryScreen extends StatefulWidget {
  final Story story;
  DetailStoryScreen({required this.story});

  @override
  State<StatefulWidget> createState() => _DetailStoryState();
}

class _DetailStoryState extends State<DetailStoryScreen>  {
  List<Story> storiesByIdCate = [];
  List<Story> storiesByIdAuthor = [];
  List<Comment> listComment = [];
  int stoId = 0;


  @override
  void initState() {
    _loadStoryByIdCategory(widget.story.category.categoryID);
    _loadStoryByIdAuthor(widget.story.author.authorId);
    _loadCommentByIdStory(widget.story.storyId);
    stoId = widget.story.storyId;
  }

  void removeStoryById(List<Story> storyList, int storyId) {
    storyList.removeWhere((story) => story.storyId == storyId);
  }

  void _loadCommentByIdStory(int storyId) async {
    final response = await CommentService().getCommentByIdStory(storyId);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        listComment = data.map((json) => Comment.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load Comment by Story');
    }
  }

  void _loadStoryByIdAuthor(int authorId) async {
    final response = await StoryService().getStoryByIdAuthor(authorId);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        storiesByIdAuthor = data.map((json) => Story.fromJson(json)).toList();
        removeStoryById(storiesByIdAuthor, widget.story.storyId);

      });
    } else {
      throw Exception('Failed to load stories by author');
    }
  }

  void _loadStoryByIdCategory(int cateId) async {
    final response = await StoryService().getStoryByIdCategory(cateId);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        storiesByIdCate = data.map((json) => Story.fromJson(json)).toList();
        removeStoryById(storiesByIdCate, widget.story.storyId);
      });
    } else {
      throw Exception('Failed to load stories by category');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: ListView(
          children: [ Container(
            color: Colors.white,  // Màu nền tối
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Hình ảnh bìa truyện
          Image.asset(
            'assets/images/pic10.jpg', // Thay thế bằng đường dẫn ảnh của bạn
            height: 250,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 30.0),
          Row(
            children: [
              // Bên trái: Hình ảnh
              Container(
                width: 120.0, // Chiều rộng của hình ảnh
                height: 120.0, // Chiều cao của hình ảnh
                margin: EdgeInsets.only(right: 16.0), // Khoảng cách giữa ảnh và văn bản
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0), // Bo tròn góc của ảnh
                  image: DecorationImage(
                    image: NetworkImage("${UriApi.api_image}${widget.story.coverImage}"), // Đường dẫn hình ảnh
                    fit: BoxFit.cover, // Đảm bảo ảnh bao phủ hết khung hình
                  ),
                ),
              ),

              // Bên phải: Thông tin story
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn văn bản sang trái
                  children: [
                    // Tiêu đề
                    Text(
                      widget.story.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),

                    // Row chứa tên tác giả và biểu tượng trái tim
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Chia đều không gian giữa tên tác giả và icon
                      children: [
                        // Tác giả
                        Text(
                          widget.story.author.authorName,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        ),

                        // Icon trái tim để thêm vào yêu thích
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border, // Icon trái tim chưa được thêm
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Xử lý sự kiện khi người dùng nhấn vào trái tim
                            // Ví dụ: Gọi hàm thêm vào yêu thích
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    // Các nút điều hướng
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildNavigationButton(widget.story.category.categoryName),
                        _buildNavigationButton('Còn tiếp'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          // Nút "Đọc Truyện"
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChapterScreen(storyId: stoId),  // Chuyển hướng đến màn hình NewPage
                  ),
                );
              }, // Hàm xử lý khi nhấn nút
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Màu nền nút
                padding: EdgeInsets.symmetric(vertical: 12.0),
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Đọc Truyện'),
            ),
          ),
          SizedBox(height: 16.0),
          // Thông tin truyện
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildInfoItem(Icons.book, '${widget.story.totalChapter}\nChương'),
              _buildInfoItem(Icons.visibility, '437\nLượt đọc'),
              _buildInfoItem(Icons.message, '${widget.story.totalComment}\nbình luận'),
              _buildInfoItem(Icons.bookmark, '${widget.story.totalFavorite}\nLưu lại'),
            ],
          ),

          SizedBox(height: 30.0),
          Center(
            child: Text(
              'Giới thiệu',  // Sửa lại chính tả 'Gới thiệu' thành 'Giới thiệu'
              style: TextStyle(
                color: Colors.black38,
                fontSize: 24.0, // Tăng kích thước chữ
                fontWeight: FontWeight.bold, // Tùy chọn: thêm độ đậm cho chữ
              ),
              textAlign: TextAlign.center, // Căn giữa chữ
            ),
          ),
          SizedBox(height: 24.0),
          Text(
            widget.story.description,
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Phản hồi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              listComment.isEmpty
                  ? Center(
                      child: Text(
                        'Chưa có bình luận nào!', // Dòng thông báo khi không có bình luận
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : CommentSection(comments: listComment),
            ],
          ), // Nếu có dữ liệu, hiển thị CommentSection
          SizedBox(height: 30.0),
          Center(
            child: Text(
              'Cùng thể loại',  // Sửa lại chính tả 'Gới thiệu' thành 'Giới thiệu'
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0, // Tăng kích thước chữ
                fontWeight: FontWeight.bold, // Tùy chọn: thêm độ đậm cho chữ
              ),
              textAlign: TextAlign.center, // Căn giữa chữ
            ),
          ),
          SizedBox(height: 10.0),
          Column(
            children: [
              storiesByIdCate.isEmpty
                  ? Center(
                      child: Text(
                        'Không có tác phẩm cùng loại !', // Dòng thông báo khi không có bình luận
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StoryCarousel(stories: storiesByIdCate), // Thêm carousel ở đây
                    ),
            ],
          ),
          SizedBox(height: 30.0),
          Center(
            child: Text(
              'Cùng tác giả',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10.0),
          Column(
            children: [
              storiesByIdAuthor.isEmpty
                  ? Center(
                      child: Text(
                        'Hiện tại chỉ có một sản phẩm !', // Dòng thông báo khi không có bình luận
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : StoryCard(stories: storiesByIdAuthor),
            ],
          ),
        ],
      ),
    ),
    ],
    ),
    );
  }

  // Hàm tạo widget cho từng mục thông tin truyện
  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: <Widget>[
        Icon(icon, color: Colors.black),
        SizedBox(height: 4.0),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  // Hàm tạo widget cho các nút điều hướng
  Widget _buildNavigationButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.orange),
      ),
    );
  }
}