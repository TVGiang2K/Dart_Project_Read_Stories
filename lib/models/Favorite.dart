import 'package:doan/models/AccountShow.dart';
import 'package:doan/models/Story.dart';

class Favorite {
  int favoriteId;
  AccountShow account;
  Story story;

  Favorite({
    required this.favoriteId,
    required this.account,
    required this.story
  });
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
        favoriteId: json['favoriteId'] ?? 0,
        account: AccountShow.fromJson(json['account'] ?? {}),
        story: Story.fromJson(json['story'] ?? {}),
    );
  }
  Map<String, Object?> toMap() {
    return {
      "favoriteId": favoriteId,
      "account": account,
      "story": story,
    };
  }
}
