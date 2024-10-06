class Favorite {
  int favoriteId;
  int acID;
  String acName;
  int storyID;
  String storyName;

  Favorite({
    required this.favoriteId,
    required this.acID,
    required this.acName,
    required this.storyID,
    required this.storyName,
  });
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
        favoriteId: json['favoriteId'] ?? 0,
        acID: json['acID'] ?? 0,
        acName: json['acName'] ?? '',
        storyID: json['storyID'] ?? 0,
        storyName: json['storyName'] ?? '',
    );
  }
  Map<String, Object?> toMap() {
    return {
      "favoriteId": favoriteId,
      "acID": acID,
      "acName": acName,
      "storyID": storyID,
      "storyName": storyName,
    };
  }
}
