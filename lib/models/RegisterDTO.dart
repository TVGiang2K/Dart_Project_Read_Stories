

class RegisterDTO
{

  String userName;
  String email;
  String password;

  RegisterDTO({
    required this.userName,
    required this.email,
    required this.password,
  });
  factory RegisterDTO.fromJson(Map<String, dynamic> json)
  {
    return RegisterDTO(
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
    };
  }
}