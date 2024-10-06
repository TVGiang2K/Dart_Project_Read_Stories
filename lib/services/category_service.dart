import 'dart:convert';
import 'package:doan/common/UriAPI.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<http.Response> getCategory()  {
    return http
        .get(Uri.parse('${UriApi.api}/Categories'), headers: headers);
  }

  Future<http.Response> getCateById(int cateID) {
    return http.get(Uri.parse('${UriApi.api}/Categories/$cateID'),
        headers: headers);
  }

}
