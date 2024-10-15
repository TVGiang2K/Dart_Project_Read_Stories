import 'dart:convert';
import 'package:doan/common/UriAPI.dart';
import 'package:doan/models/ComentDTOInsert.dart';
import 'package:http/http.dart' as http;

class CommentService {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<http.Response> getCommentByIdStory(int storyID) {
    return http.get(Uri.parse('${UriApi.api}/Comment/Story/$storyID'),
        headers: headers);
  }

  Future<http.Response> getCommentByIdUser(int acID) {
    return http.get(Uri.parse('${UriApi.api}/Comment/User/$acID'),
        headers: headers);
  }

  Future<http.Response> deleteComment(int commentId){
    return http.delete(Uri.parse('${UriApi.api}/Comment/$commentId'));
  }

  Future<http.Response> insertComment(ComentDTOInsert comment) {
    return http.post(
      Uri.parse('${UriApi.api}/Comment'),
      headers: headers,
      body: json.encode(comment.toJson()),
    );
  }

}
