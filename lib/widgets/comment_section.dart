import 'package:flutter/material.dart';
import 'package:doan/models/AccountShow.dart';
import 'package:doan/models/Comment.dart';

class CommentSection extends StatelessWidget {
  final List<Comment> comments;

  const CommentSection({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: comments.map((comment) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/user.jpg'), // Sử dụng AssetImage để hiển thị ảnh từ assets
              radius: 24.0,
            ),
            title: Text(
              comment.account.userName, // Tên người dùng
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(comment.content), // Nội dung bình luận
              ],
            ),
          ),
        );
      }).toList(), // Chuyển List<Comment> thành danh sách các widget Card
    );
  }
}
