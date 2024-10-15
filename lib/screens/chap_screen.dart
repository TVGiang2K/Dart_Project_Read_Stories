import 'dart:convert';

import 'package:doan/models/AccountShow.dart';
import 'package:doan/models/Category.dart';
import 'package:doan/models/Chapter.dart';
import 'package:doan/models/Comment.dart';
import 'package:doan/models/Story.dart';
import 'package:doan/screens/base_screen.dart';
import 'package:doan/services/chapter_service.dart';
import 'package:doan/services/commnet_service.dart';
import 'package:doan/services/story_service.dart';
import 'package:doan/widgets/comment_form.dart';
import 'package:doan/widgets/comment_section.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterScreen extends StatefulWidget {
  final int storyId;

  ChapterScreen({required this.storyId});
  @override
  State<StatefulWidget> createState() => _ChapStoryScreen();
}



class _ChapStoryScreen extends State<ChapterScreen> {
  Map<String, String> headers = <String, String>{};
  List<Category> categories = [];
  List<Chapter> listChapter = [];
  List<Comment> listComment = [];
  int _chapterId = 1;
  Story? story;
  Chapter? chapter;
  int acId = 0;


  @override
  void initState() {
    super.initState();
    _loadListChapter();
    _loadCommentByIdStory();
    _loadStory();
    _loadChapter(_chapterId);
    _loadUserName();
  }

  Future<AccountShow?> getAccount() async {
    final prefs = await SharedPreferences.getInstance();
    String? accountJson = prefs.getString('account');

    if (accountJson != null) {
      Map<String, dynamic> json = jsonDecode(accountJson);
      return AccountShow.fromJson(json);
    }
    return null;
  }

  Future<void> _loadUserName() async {
    AccountShow? account = await getAccount();
    if (account != null) {
      setState(() {
        acId = account.acId;
      });
    } else{
      acId = 0;
    }
    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer '
    };
  }

  void _loadStory() async {
    final response = await StoryService().getStoryById(widget.storyId);
    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        // Kiểm tra nếu 'result' không phải null rồi mới tạo đối tượng Story
        story = Story.fromJson(data);
      });
    } else {
      throw Exception('Failed to load Story');
    }
  }

  void _loadChapter(int chapterId) async {
    final response = await ChapterService().getChapterById(chapterId);
    if (response.statusCode == 200) {
      //print(response.body);
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        chapter = Chapter.fromJson(data);
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
                    story == null ? '' : story!.title,  // Sửa lại chính tả 'Gới thiệu' thành 'Giới thiệu'
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
                      IconButton(
                        icon: Icon(Icons.navigate_before_sharp),
                        onPressed: () {
                          setState(() {
                            if (_chapterId != null) {
                              int index = listChapter.indexWhere((chapter) => chapter.chapterId == _chapterId);
                              if (index > 0) {
                                setState(() {
                                  _chapterId = listChapter[index - 1].chapterId;
                                  _loadChapter(_chapterId);
                                });
                              }
                            } else if (listChapter.isNotEmpty) {
                              setState(() {
                                _chapterId = listChapter[0].chapterId;
                                _loadChapter(_chapterId);
                              });
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
                              if (value != null) {
                                setState(() {
                                  _chapterId = value;
                                });
                                _loadChapter(_chapterId);
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
                                setState(() {
                                  _chapterId = listChapter[index + 1].chapterId;
                                  _loadChapter(_chapterId);
                                });
                              }
                            } else if (listChapter.isNotEmpty) {
                              setState(() {
                                _chapterId = listChapter[0].chapterId;
                                _loadChapter(_chapterId);
                              });
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
                  chapter == null ? '' : 'Chapter: ${chapter!.chapterNumber}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                // Phần thân
                Text(
                  chapter == null ? '' : 'Tiêu đề : ${chapter!.chapterTitle}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  chapter == null ? '' : chapter!.content,
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
                                        setState(() {
                                          _chapterId = listChapter[index - 1].chapterId;
                                          _loadChapter(_chapterId);
                                        });
                                      }
                                    } else if (listChapter.isNotEmpty) {
                                      setState(() {
                                        _chapterId = listChapter[0].chapterId;
                                        _loadChapter(_chapterId);
                                      });
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
                                      if (value != null) {
                                        setState(() {
                                          _chapterId = value;
                                        });
                                        _loadChapter(_chapterId);
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
                                        setState(() {
                                        _chapterId = listChapter[index + 1].chapterId;
                                        _loadChapter(_chapterId);
                                        });
                                      }
                                    } else if (listChapter.isNotEmpty) {
                                      setState(() {
                                        _chapterId = listChapter[0].chapterId;
                                        _loadChapter(_chapterId);
                                      });
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
                acId == 0 || story == null || chapter == null
                ? SizedBox.shrink()
                : CommentFormWidget(
                    accountId: acId,
                    storyId: story!.storyId,
                    chapterId: chapter!.chapterId,
                    onSubmit: (accountId, storyId, chapterId, content) {
                      print('Bình luận đã được gửi: $content');
                    },
                    onCommentAdded: () {
                      _loadCommentByIdStory();
                    },
                  ),

          ],
        ),
      ),
    ),
    );
  }
}