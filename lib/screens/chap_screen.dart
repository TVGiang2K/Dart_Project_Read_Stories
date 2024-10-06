import 'dart:convert';

import 'package:doan/models/Category.dart';
import 'package:doan/models/Chapter.dart';
import 'package:doan/models/Comment.dart';
import 'package:doan/models/Story.dart';
import 'package:doan/screens/base_screen.dart';
import 'package:doan/services/category_service.dart';
import 'package:doan/services/chapter_service.dart';
import 'package:doan/services/commnet_service.dart';
import 'package:doan/services/story_service.dart';
import 'package:doan/widgets/comment_section.dart';
import 'package:flutter/material.dart';

class ChapterScreen extends StatefulWidget {
  final int storyId;

  ChapterScreen({required this.storyId});
  @override
  State<StatefulWidget> createState() => _ChapStoryScreen();
}



class _ChapStoryScreen extends State<ChapterScreen> {
  List<Category> categories = [];
  List<Chapter> listChapter = [];
  List<Comment> listComment = [];
  int? _chapterId = 1;
  Story? story;
  Chapter? chapter;

  @override
  void initState() {
    super.initState();
    _loadListChapter();
    _loadCommentByIdStory();
    _loadStory();
  }

  void _loadStory() async {
    final response = await StoryService().getStoryById(widget.storyId);
    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(response.body);
      setState(() {
        // Kiểm tra nếu 'result' không phải null rồi mới tạo đối tượng Story
        story = Story.fromJson(data['result']);
      });
    } else {
      throw Exception('Failed to load Story');
    }
  }

  void _loadChapter(int chapterId) async {
    final response = await ChapterService().getChapterById(chapterId);
    if (response.statusCode == 200) {
      //print(response.body);
      final data = json.decode(response.body);
      setState(() {
        chapter = Chapter.fromJson(data['result']);
      });
    } else {
      throw Exception('Failed to load Story');
    }
  }

  void _loadListChapter() async {
    final response = await ChapterService().getChapterByIdStory(widget.storyId);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        listChapter = data.map((json) => Chapter.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load chapter');
    }
  }



  void _loadCommentByIdStory() async {
    final response = await CommentService().getCommentByIdStory(widget.storyId);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        listComment = data.map((json) => Comment.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load comment by Story');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ // Thay thế bằng đường dẫn hình ảnh của bạn
                Center(
                  child: Text(
                    'story!.title',  // Sửa lại chính tả 'Gới thiệu' thành 'Giới thiệu'
                    style: TextStyle(
                      fontSize: 30, // Tăng kích thước chữ
                      fontWeight: FontWeight.bold, // Tùy chọn: thêm độ đậm cho chữ
                    ),
                    textAlign: TextAlign.center, // Căn giữa chữ
                  ),
                ),
                Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Sử dụng để chỉ chiếm không gian tối thiểu
                      children: [
                      const Text('Chọn Chương'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nút giảm
                      IconButton(
                        icon: Icon(Icons.navigate_before_sharp),
                        onPressed: () {
                          setState(() {
                            if (_chapterId != null) {
                              int index = listChapter.indexWhere((chapter) => chapter.chapterId == _chapterId);
                              if (index > 0) {
                                // Giảm xuống một chương
                                _chapterId = listChapter[index - 1].chapterId;
                              }
                            } else if (listChapter.isNotEmpty) {
                              // Nếu chưa chọn chương nào, chọn chương đầu tiên
                              _chapterId = listChapter[0].chapterId;
                            }
                          });
                        },
                      ),


                      // DropdownButton
                      if (listChapter.isNotEmpty)
                        DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            hint: const Text('Chương'),
                            items: [
                              DropdownMenuItem<int>(
                                value: null,
                                child: Text('Chọn chương'),
                              ),
                              ...listChapter.map((Chapter item) => DropdownMenuItem<int>(
                                value: item.chapterId,
                                child: Text(item.chapterNumber.toString()),
                              )),
                            ],
                            value: _chapterId,
                            onChanged: (int? value) {
                              setState(() {
                                _chapterId = value;
                              });
                              if (value != null) {
                                _loadChapter(value);
                              }
                            },
                          ),
                        ),

                      // Nút tăng
                      IconButton(
                        icon: Icon(Icons.navigate_next_sharp),
                        onPressed: () {
                          setState(() {
                            if (_chapterId != null) {
                              int index = listChapter.indexWhere((chapter) => chapter.chapterId == _chapterId);
                              if (index < listChapter.length - 1) {
                                // Tăng lên một chương
                                _chapterId = listChapter[index + 1].chapterId;
                              }
                            } else if (listChapter.isNotEmpty) {
                              // Nếu chưa chọn chương nào, chọn chương đầu tiên
                              _chapterId = listChapter[0].chapterId;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                        ]
                  )

                ),

                Text(
                  'chapter!.chapterTitle',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                // Phần thân
                Text(
                  'Chương 01: Gió của mùa hè',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Thành phố Kim Cảng lại bị gọi là City of Angels.\n\nCảng lớn thứ ba thế giới, lưu lượng một ngày thứ nhất ở Bắc bán cầu, đối với tòa thành thị này mọi người có lấy quá nhiều mỹ từ!',
                  style: TextStyle(fontSize: 16),
                ),
                Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.min, // Sử dụng để chỉ chiếm không gian tối thiểu
                        children: [
                          const Text('Chọn Chương'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Nút giảm
                              IconButton(
                                icon: Icon(Icons.navigate_before_sharp),
                                onPressed: () {
                                  setState(() {
                                    if (_chapterId != null) {
                                      int index = listChapter.indexWhere((chapter) => chapter.chapterId == _chapterId);
                                      if (index > 0) {
                                        // Giảm xuống một chương
                                        _chapterId = listChapter[index - 1].chapterId;
                                      }
                                    } else if (listChapter.isNotEmpty) {
                                      // Nếu chưa chọn chương nào, chọn chương đầu tiên
                                      _chapterId = listChapter[0].chapterId;
                                    }
                                  });
                                },
                              ),

                              // DropdownButton
                              if (listChapter.isNotEmpty)
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    hint: const Text('Chương'),
                                    items: [
                                      DropdownMenuItem<int>(
                                        value: null,
                                        child: Text('Chọn chương'),
                                      ),
                                      ...listChapter.map((Chapter item) => DropdownMenuItem<int>(
                                        value: item.chapterId,
                                        child: Text(item.chapterNumber.toString()),
                                      )),
                                    ],
                                    value: _chapterId,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _chapterId = value;
                                      });
                                      if (value != null) {
                                        _loadChapter(value);
                                      }

                                    },
                                  ),
                                ),

                              // Nút tăng
                              IconButton(
                                icon: Icon(Icons.navigate_next_sharp),
                                onPressed: () {
                                  setState(() {
                                    if (_chapterId != null) {
                                      int index = listChapter.indexWhere((chapter) => chapter.chapterId == _chapterId);
                                      if (index < listChapter.length - 1) {
                                        // Tăng lên một chương
                                        _chapterId = listChapter[index + 1].chapterId;
                                      }
                                    } else if (listChapter.isNotEmpty) {
                                      // Nếu chưa chọn chương nào, chọn chương đầu tiên
                                      _chapterId = listChapter[0].chapterId;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ]
                    )

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
                ),

          ],
        ),
      ),
    ),
    );
  }
}