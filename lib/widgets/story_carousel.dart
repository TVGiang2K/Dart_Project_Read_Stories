import 'dart:async';
import 'package:doan/common/UriAPI.dart';
import 'package:doan/models/Story.dart';
import 'package:doan/screens/detail_story_screen.dart';
import 'package:flutter/material.dart';

class StoryCarousel extends StatefulWidget {
  final List<Story> stories;

  StoryCarousel({required this.stories});

  @override
  _StoryCarouselState createState() => _StoryCarouselState();
}

class _StoryCarouselState extends State<StoryCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;
  final int _itemsPerPage = 3; // Số lượng truyện hiển thị mỗi lần

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9); // Mỗi mục chiếm 90% chiều rộng màn hình
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < (widget.stories.length / _itemsPerPage).floor()) {
        _currentPage++;
      } else {
        _currentPage = 0; // Quay lại đầu khi đến cuối danh sách
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Chiều cao của carousel (tăng thêm chiều cao)
      child: PageView.builder(
        controller: _pageController,
        itemCount: (widget.stories.length / _itemsPerPage).ceil(), // Tổng số trang
        itemBuilder: (context, pageIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Sử dụng spaceEvenly để cân đối khoảng cách
            children: List.generate(_itemsPerPage, (index) {
              final storyIndex = pageIndex * _itemsPerPage + index;
              if (storyIndex < widget.stories.length) {
                final story = widget.stories[storyIndex];

                // Sử dụng GestureDetector để bọc Image
                return Expanded( // Đảm bảo mỗi Card chiếm không gian đều
                  child: GestureDetector(
                    onTap: () {
                      // Điều hướng đến màn hình chi tiết
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailStoryScreen(story: story),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            "${UriApi.api_image}${story.coverImage}",
                            fit: BoxFit.cover,
                            height: 120, // Chiều cao hình ảnh
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              story.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink(); // Trả về widget trống nếu không còn truyện
              }
            }),
          );
        },
      ),
    );
  }
}

// Ví dụ màn hình chi tiết Story
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