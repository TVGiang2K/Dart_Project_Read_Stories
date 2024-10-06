import 'dart:convert';
import 'package:doan/models/Category.dart';
import 'package:doan/models/Story.dart';
import 'package:doan/services/category_service.dart';
import 'package:doan/services/story_service.dart';
import 'package:flutter/material.dart';
import '../widgets/story_card.dart';
import 'base_screen.dart';

class ListStoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListStoryState();
}

class _ListStoryState extends State<ListStoryScreen> {
  List<Category> categories = [];
  List<Story> storiesByIdCate = [];
  List<Story> stories = [];
  int? _cateId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadStory();
  }

  void _loadCategories() async {
    final response = await CategoryService().getCategory();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        categories = data.map((json) => Category.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void _loadStory() async {
    final response = await StoryService().getStory();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        stories = data.map((json) => Story.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load stories');
    }
  }

  void _loadStoryByIdCategory(int cateId) async {
    final response = await StoryService().getStoryByIdCategory(cateId);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        storiesByIdCate = data.map((json) => Story.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load stories by category');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: ListView(
        children: [
          // Banner image
          Container(
            margin: EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/pic2.jpg",
              fit: BoxFit.fill,
            ),
          ),
          // List of stories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(height: 10.0),
                    Container(
                      color: Colors.black12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Thể Loại :'),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              isExpanded: false,
                              items: [
                                DropdownMenuItem<int>(
                                  value: null,
                                  child: Text('Tất cả thể loại'),
                                ),
                                // Add existing categories
                                ...categories.map((Category item) => DropdownMenuItem<int>(
                                  value: item.categoryID,
                                  child: Text(item.categoryName),
                                )),
                              ],
                              value: _cateId,
                              onChanged: (int? value) {
                                setState(() {
                                  _cateId = value; // Set the selected category
                                });
                                if (value != null) {
                                  _loadStoryByIdCategory(value);
                                } else {
                                  storiesByIdCate.clear(); // Clear stories if "All Categories" is selected
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                (_cateId == null ? StoryCard(stories: stories) : StoryCard(stories: storiesByIdCate)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
