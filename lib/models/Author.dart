class Author
{
  int authorId;
  String authorName;
  String bio;

  Author({
    required this.authorId,
    required this.authorName,
    required this.bio
  });

  factory Author.fromJson(Map<String, dynamic> json)
  {
    return Author(
        authorId: json['authorId'] ?? 0,
        authorName: json['authorName'] ?? '',
        bio: json['bio'] ?? '',

    );
  }

  Map<String, Object?> toMap() {
    return {
      "authorId": authorId,
      "authorName": authorName,
      "bio": bio,
    };
  }
}