import 'package:doan/models/AccountShow.dart';
import 'package:doan/models/Story.dart';

class FavoriteDTOInsert {
  int accountId;
  int storyId;


  FavoriteDTOInsert(
      {
        required this.accountId,
        required this.storyId,
      }); // Sửa hàm khởi tạo

  factory FavoriteDTOInsert.fromJson(Map<String, dynamic> json) {
    return FavoriteDTOInsert(
      accountId: json['accountId'] ?? 0,
      storyId:  json['storyId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'storyId': storyId,
    };
  }
}