import 'dart:convert';

import 'package:doan/models/Story.dart';
import 'package:doan/screens/home_screen.dart';
import 'package:doan/screens/list_story_screen.dart';
import 'package:doan/screens/register_screen.dart';
import 'package:doan/screens/user_info_screen.dart';
import 'package:doan/services/story_service.dart';
import 'package:doan/widgets/story_card.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;

  BaseScreen({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: StorySearchDelegate());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black87),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Thực hiện điều hướng đến trang thông tin người dùng
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInfoScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 8), // Khoảng cách giữa biểu tượng và tên
                        Text(
                          'userName',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Trang Chủ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Thể Loại'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListStoryScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Đăng Nhập'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_outlined),
              title: Text('Đăng Ký'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: body,
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //         height: MediaQuery.of(context).size.height - 200,
      //         child: body, // Nội dung chính
      //       ),
      //       Container(
      //         padding: EdgeInsets.all(16.0),
      //         color: Colors.grey[200],
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               'Thông tin liên hệ',
      //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //             ),
      //             SizedBox(height: 8.0),
      //             Text('Email: contact@example.com'),
      //             Text('Số điện thoại: 0123-456-789'),
      //             SizedBox(height: 8.0),
      //             Text(
      //               '© 2024 Bản quyền thuộc về Công ty ABC',
      //               style: TextStyle(color: Colors.grey),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}





class StorySearchDelegate extends SearchDelegate {
  Future<List<Story>> fetchSearchResults(String name) async {
    // Gọi API và nhận phản hồi
    final response = await StoryService().getStorySearch(name);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Story.fromJson(json)).toList(); // Trả về danh sách câu chuyện
    } else {
      throw Exception('Không thể tải dữ liệu');
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Xóa query khi nhấn nút
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Đóng SearchDelegate
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Story>>(
      future: fetchSearchResults(query), // Gọi API ở đây
      builder: (BuildContext context, AsyncSnapshot<List<Story>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Hiện vòng xoay khi đang tải
        } else if (snapshot.hasError) {
          return Center(child: Text('Có lỗi: ${snapshot.error}')); // Hiện thông báo lỗi
        } else {
          final results = snapshot.data ?? [];
          return StoryCard(stories: results); // Sử dụng StoryCard để hiển thị danh sách
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            query = value; // Cập nhật giá trị của query
          },
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                title: Text('Gợi ý 1 cho "$query"'),
              ),
              ListTile(
                title: Text('Gợi ý 2 cho "$query"'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
