class LoginDTO
{
  String userName;
  String password;

  LoginDTO({
    required this.userName,
    required this.password,
  });

  factory LoginDTO.fromJson(Map<String, dynamic> json)
  {
    return LoginDTO(
      userName: json['userName'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
    };
  }
}