import 'package:doan/common/UriAPI.dart';
import 'package:doan/models/Story.dart';
import 'package:flutter/material.dart';

class StoryDetailScreen extends StatelessWidget {
  final Story story;

  StoryDetailScreen({required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network("${UriApi.api_image}${story.coverImage}"),
            SizedBox(height: 16),
            Text(
              story.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(story.description), // Hiển thị mô tả của câu chuyện
          ],
        ),
      ),
    );
  }
}