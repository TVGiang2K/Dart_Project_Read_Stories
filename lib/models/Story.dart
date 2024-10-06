import 'package:doan/models/Author.dart';
import 'package:doan/models/Category.dart';
import 'package:doan/models/Chapter.dart';
import 'package:doan/models/Comment.dart';

class Story
{
  int storyId;
  String title;
  String description;
  String coverImage;
  Category category;
  Author author;
  int totalChapter;
  int totalComment;
  int totalFavorite;

  Story({
    required this.storyId,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.category,
    required this.author,
    required this.totalChapter,
    required this.totalComment,
    required this.totalFavorite

  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      storyId: json['storyId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      author: Author.fromJson(json['author'] ?? {}),
      totalChapter: json['totalChapter'] ?? 0,
      totalComment: json['totalComment'] ?? 0,
      totalFavorite: json['totalFavorite'] ?? 0
    );
  }
}