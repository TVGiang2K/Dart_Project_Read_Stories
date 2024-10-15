import 'package:doan/models/AccountShow.dart';
import 'package:doan/models/Story.dart';

class Comment {
  int commentId;
  String content;
  AccountShow account;
  Story story; // Thêm thuộc tính storyName

  Comment(
      {required this.commentId,
        required this.content,
        required this.account,
        required this.story}); // Sửa hàm khởi tạo

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'] ?? 0,
      content: json['content'] ?? '',
      account: AccountShow.fromJson(json['account'] ?? {}),
      story: Story.fromJson(json['story'] ?? {}),// Thêm storyName vào đây
    );
  }
}