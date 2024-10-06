import 'package:doan/models/AccountShow.dart';

class Comment {
  int commentId;
  String content;
  AccountShow account;
  int storyId;
  String storyName; // Thêm thuộc tính storyName

  Comment(
      {required this.commentId,
        required this.content,
        required this.account,
        required this.storyId,
        required this.storyName}); // Sửa hàm khởi tạo

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'] ?? 0,
      content: json['content'] ?? '',
      account: AccountShow.fromJson(json['account'] ?? {}),
      storyId: json['storyId'] ?? 0,
      storyName: json['storyName'] ?? '', // Thêm storyName vào đây
    );
  }
}