import 'package:doan/common/UriAPI.dart';
import 'package:flutter/material.dart';
import 'package:doan/screens/detail_story_screen.dart';
import 'package:doan/models/Story.dart'; // Giả sử bạn có model Story

class StoryCard extends StatelessWidget {
  final List<Story> stories; // Nhận danh sách các câu chuyện

  const StoryCard({
    Key? key,
    required this.stories, // Truyền list Story vào
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: stories.map((story) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: Image.network(
              "${UriApi.api_image}${story.coverImage}", // URL hình ảnh
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              story.title, // Tiêu đề câu chuyện
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tác Giả: ${story.author}', // Tác giả
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(height: 4),
                Text(
                  'Thể Loại: ${story.category.categoryName}', // Thể loại
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailStoryScreen(story: story,),
                ),
              );
            },
          ),
        );
      }).toList(), // Chuyển List<Story> thành danh sách các widget Card
    );
  }
}