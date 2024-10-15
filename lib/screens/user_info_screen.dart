import 'dart:convert';

import 'package:doan/common/UriAPI.dart';
import 'package:doan/models/AccountShow.dart';
import 'package:doan/models/Comment.dart';
import 'package:doan/models/Favorite.dart';
import 'package:doan/screens/detail_story_screen.dart';
import 'package:doan/services/commnet_service.dart';
import 'package:doan/services/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfoScreen> {
  Map<String, String> headers = <String, String>{};
  AccountShow? account;
  List<Comment> listComment = [];
  List<Favorite> listFavorite = [];

  @override
  void initState() {
    super.initState();
    getAccount();
  }

  Future<void> getAccount() async {
    final prefs = await SharedPreferences.getInstance();
    String? accountJson = prefs.getString('account');

    if (accountJson != null) {
      Map<String, dynamic> json = jsonDecode(accountJson);
      setState(() {
        account = AccountShow.fromJson(json);
        headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer '
        };
      });
      _loadListComment();
      _loadListFavorite();
    }
    return null;
  }

  void _loadListComment() async {
    final response = await CommentService().getCommentByIdUser(account!.acId);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        listComment = data.map((json) => Comment.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load Comment by User');
    }
  }

  Future<bool> _deleteFavorite(int favoriteId) async {
    try {
      final response = await FavoriteService().deleteFavorite(favoriteId);
      if (response.statusCode == 200) {
        setState(() {
          listFavorite.removeWhere((favorite) => favorite.favoriteId == favoriteId);
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> _deleteComment(int commentId) async {
    try {
      final response = await CommentService().deleteComment(commentId);
      if (response.statusCode == 200) {
        setState(() {
          listComment.removeWhere((comment) => comment.commentId == commentId);
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void _loadListFavorite() async {
    final response = await FavoriteService().getFavoriteByIdUser(account!.acId);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        listFavorite = data.map((json) => Favorite.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load Favorite by User');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông Tin Người Dùng'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.account_circle,
                size: 100.0,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              account == null ? '' : account!.userName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              account == null ? '' : account!.email,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Dach sách truyện yêu thích:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listFavorite.length,
                itemBuilder: (context, index) {
                  final favorite = listFavorite[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            "${UriApi.api_image}${favorite.story.coverImage}", // Link ảnh của story
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(favorite.story.title),
                      subtitle: Text('Thể loại: ${favorite.story.category.categoryName}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite, color: Colors.red),
                            onPressed: () {
                              // Xử lý logic thêm vào yêu thích (nếu cần)
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey),
                            onPressed: () async {
                              // Hàm xóa story
                              bool success = await _deleteFavorite(favorite.favoriteId);
                              // Hiển thị thông báo
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Bỏ yêu thích thành công!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Bỏ yêu thích không thành công!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailStoryScreen(story: favorite.story),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Dach sách truyện đã bình luận:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listComment.length,
                itemBuilder: (context, index) {
                  final comment = listComment[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            "${UriApi.api_image}${comment.story.coverImage}", // Link ảnh của story
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(comment.story.title),
                      subtitle: Text('Nội Dung: "${comment.content}"'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.comment, color: Colors.blue),
                            onPressed: () {
                              // Xử lý logic thêm vào yêu thích (nếu cần)
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey),
                            onPressed: () async {
                              // Hàm xóa story
                              bool success = await _deleteComment(comment.commentId);
                              // Hiển thị thông báo
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Xóa thành công!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Xóa không thành công!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailStoryScreen(story: comment.story),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
