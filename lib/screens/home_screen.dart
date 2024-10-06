import 'dart:convert';
import 'package:doan/common/UriAPI.dart';
import 'package:doan/models/Story.dart';
import 'package:doan/screens/list_story_screen.dart';
import 'package:doan/services/story_service.dart';
import 'package:doan/widgets/story_carousel.dart';
import 'package:flutter/material.dart';
import '../widgets/story_card.dart';
import 'base_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Story> stories = [];
  List<Story> storiesNew = [];
  List<Story> storiesFavorite = [];
  Map<String, String> headers = <String, String>{};
  String? _fullName;
  String? _avatar;

  @override
  void initState() {
    super.initState();
    _loadStory();
    _loadStoryNew();
    _loadStoryFavorite();

  }

  void _loadStory() async {
    final response = await StoryService().getStory();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes)); // API trả về một danh sách (List)
      setState(() {
        stories = data.map((json) => Story.fromJson(json)).toList();
        // Ánh xạ từng phần tử trong danh sách
      });
    } else {
      throw Exception('Failed to load stories');
    }
  }

  void _loadStoryNew() async {
    final response = await StoryService().getStoryNew();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes)); // API trả về một danh sách (List)
      setState(() {
        storiesNew = data.map((json) => Story.fromJson(json)).toList(); // Ánh xạ từng phần tử trong danh sách
      });
    } else {
      throw Exception('Failed to load stories');
    }
  }

  void _loadStoryFavorite() async {
    final response = await StoryService().getStoryFavorite();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes)); // API trả về một danh sách (List)
      setState(() {
        storiesFavorite = data.map((json) => Story.fromJson(json)).toList(); // Ánh xạ từng phần tử trong danh sách
      });
    } else {
      throw Exception('Failed to load stories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: ListView(
        children: [
          // Banner hoặc ảnh chính
          Container(
            margin: EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/pic9.jpg",
              fit: BoxFit.fill
            ), // Ảnh bìa
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StoryCarousel(stories: stories), // Thêm carousel ở đây
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column( // Đổi từ Row thành Column nếu muốn có stories dưới dòng tiêu đề
              children: [
                Row(
                  children: [
                    Text(
                      'Truyện Mới',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(), // Đẩy chữ "Xem thêm" sát về bên phải
                    GestureDetector(
                      onTap: () {
                        // Thêm hành động khi nhấn vào chữ "Xem thêm"
                        print('Xem thêm được nhấn');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ListStoryScreen()),
                        );
                        // Bạn có thể thêm điều hướng sang một trang khác ở đây
                      },
                      child: Text(
                        'Xem thêm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // Thêm màu sắc cho chữ "Xem thêm"
                        ),
                      ),
                    ),
                  ],
                ),
                // Đảm bảo stories không nằm trong Row, có thể dùng Column nếu cần
                StoryCard(
                  stories: storiesNew, // Truyền danh sách câu chuyện vào đây
                ) // Đảm bảo chuyển đổi map thành danh sách
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column( // Đổi từ Row thành Column nếu muốn có stories dưới dòng tiêu đề
              children: [
                Row(
                  children: [
                    Text(
                      'Truyện Đề Cử',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print('Xem thêm được nhấn');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ListStoryScreen()),
                        );
                      },
                      child: Text(
                        'Xem thêm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                StoryCard(
                  stories: storiesFavorite, // Truyền danh sách câu chuyện vào đây
                )
                 // Đảm bảo chuyển đổi map thành danh sách
              ],
            ),
          ),
        ],
      ),
    );
  }
}

