import 'dart:convert';
import 'package:doan/common/UriAPI.dart';
import 'package:http/http.dart' as http;

class StoryService {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<http.Response> getStory()  {
    return http
        .get(Uri.parse('${UriApi.api}/Story'), headers: headers);
  }

  Future<http.Response> getStoryNew()  {
    return http
        .get(Uri.parse('${UriApi.api}/GetUpToDownStoryTop5'), headers: headers);
  }

  Future<http.Response> getStoryFavorite()  {
    return http
        .get(Uri.parse('${UriApi.api}/GetFavotireStoryTop5'), headers: headers);
  }

  // Future<http.Response> SearchStoryByIdName(String name) {
  //   return http.get(Uri.parse('${UriApi.api}/StoryByName/$name'),
  //       headers: headers);
  // }

  Future<http.Response> getStorySearch(String name) {
    return SearchStoryByIdName(name); // Gọi phương thức tìm kiếm với tên
  }

  Future<http.Response> SearchStoryByIdName(String name) {
    return http.get(Uri.parse('${UriApi.api}/StoryByName/$name'), headers: headers);
  }

  Future<http.Response> getStoryByIdCategory(int cateID) {
    return http.get(Uri.parse('${UriApi.api}/Story/Category/$cateID'),
        headers: headers);
  }

  Future<http.Response> getStoryByIdAuthor(int cateID) {
    return http.get(Uri.parse('${UriApi.api}/Story/Author/$cateID'),
        headers: headers);
  }

  Future<http.Response> getStoryById(int cateID) {
    return http.get(Uri.parse('${UriApi.api}/Story/$cateID'),
        headers: headers);
  }
}
