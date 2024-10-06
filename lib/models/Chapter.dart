class Chapter {
  int chapterId;
  String chapterTitle;
  String content;
  int chapterNumber;

  Chapter({
    required this.chapterId,
    required this.chapterTitle,
    required this.content,
    required this.chapterNumber
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
        chapterId: json['chapterId'] ?? 0,
        chapterTitle: json['chapterTitle'] ?? '',
        content: json['content'] ?? '',
        chapterNumber: json['chapterNumber'] ?? 0,
    );
  }

  factory Chapter.fromJsonObject(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapterId'] ?? 0,
      chapterTitle: json['chapterTitle'] ?? '',
      content: json['content'] ?? '',
      chapterNumber: json['chapterNumber'] ?? 0,
    );
  }

  Map<String, Object?> toMap() {
    return {
      "chapterId": chapterId,
      "chapterTitle": chapterTitle,
      "content": content,
      "chapterNumber": chapterNumber,
    };
  }
}
