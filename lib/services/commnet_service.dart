import 'dart:convert';
import 'package:doan/common/UriAPI.dart';
import 'package:http/http.dart' as http;

class CommentService {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<http.Response> getCommentByIdStory(int storyID) {
    return http.get(Uri.parse('${UriApi.api}/Comment/Story/$storyID'),
        headers: headers);
  }
}
