import 'package:doan/models/AccountShow.dart';
import 'package:doan/models/Story.dart';

class ComentDTOInsert {
  int accountId;
  int storyId;
  int chapterId;
  String content;

  ComentDTOInsert(
      {
        required this.accountId,
        required this.storyId,
        required this.chapterId,
        required this.content,
      }); // Sửa hàm khởi tạo

  factory ComentDTOInsert.fromJson(Map<String, dynamic> json) {
    return ComentDTOInsert(
      accountId: json['accountId'] ?? 0,
      storyId:  json['storyId'] ?? 0,
      chapterId:  json['chapterId'] ?? 0,// Thêm storyName vào đây
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'storyId': storyId,
      'chapterId': chapterId,
      'content': content,
    };
  }
}