import 'dart:convert';

import 'package:doan/models/AccountShow.dart';
import 'package:doan/models/LoginDTO.dart';
import 'package:doan/screens/home_screen.dart';
import 'package:doan/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:doan/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<LoginScreen> {

  final AccountService _accountService = AccountService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final responsecheckUserName = await _accountService.checkUserName(_usernameController.text);

      List<String> errorMessages = [];

      if (!responsecheckUserName) {
        errorMessages.add('Username không tồn tại');
      }

      if (errorMessages.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessages.join('\n'),
              style: TextStyle(color: Colors.red),
            ),
            backgroundColor: Colors.white,
          ),
        );
      } else {
        LoginDTO dataCheck = LoginDTO(
            userName: _usernameController.text,
            password: _passwordController.text
        );

        final response = await _accountService.login(dataCheck);
        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          var dataAccount = AccountShow.fromJson(data);
          var prefs = await SharedPreferences.getInstance();
          String accountJson = jsonEncode(dataAccount.toJson());
          await prefs.setString('account', accountJson);
          if (!context.mounted) return;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Mật khẩu không chính xác!',
                style: TextStyle(color: Colors.red),
              ),
              backgroundColor: Colors.white,
            ),
          );
        }
      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mật khẩu không chính xác!',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Nhập'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 100.0,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        'Chào mừng trở lại!',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(

                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                          labelText: 'Mật khẩu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 80.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          'Đăng Nhập',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          // Chuyển đến màn hình đăng ký
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Chưa có tài khoản? Đăng ký',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
            )
        ),
      ),
    );
  }
}
