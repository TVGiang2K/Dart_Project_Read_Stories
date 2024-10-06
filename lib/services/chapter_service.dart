import 'dart:convert';
import 'package:doan/common/UriAPI.dart';
import 'package:http/http.dart' as http;

class ChapterService {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<http.Response> getChapterByIdStory(int storyID)  {
    return http
        .get(Uri.parse('${UriApi.api}/Chapter/Story/$storyID'), headers: headers);
  }

  Future<http.Response> getChapterById(int chapterID) {
    return http.get(Uri.parse('${UriApi.api}/Chapter/$chapterID'),
        headers: headers);
  }

}
