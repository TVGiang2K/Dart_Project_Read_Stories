import 'dart:convert';
import 'package:doan/common/UriAPI.dart';
import 'package:doan/models/LoginDTO.dart';
import 'package:doan/models/RegisterDTO.dart';
import 'package:http/http.dart' as http;

class AccountService {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };


  Future<http.Response> register(RegisterDTO register) {
    return http.post(
      Uri.parse('${UriApi.api}/Register'),
      headers: headers,
      body: json.encode(register.toJson()),
    );
  }

  Future<http.Response> login(LoginDTO login) {
    return http.post(
      Uri.parse('${UriApi.api}/LoginFlutter'),
      headers: headers,
      body: json.encode(login.toJson()),
    );
  }



  Future<bool> checkUserName(String username) async {
    final response = await http.get(
      Uri.parse('${UriApi.api}/CheckAccountByUserName/$username'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Lỗi khi kiểm tra tài khoản');
    }
  }

  Future<bool> checkEmail(String email) async {
    final response = await http.get(
      Uri.parse('${UriApi.api}/CheckAccountByEmail/$email'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Lỗi khi kiểm tra tài khoản');
    }
  }

}
