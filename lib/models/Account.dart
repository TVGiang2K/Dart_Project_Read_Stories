class Account
{

  int acId;
  String userName;
  String email;
  String password;

  Account({
    required this.acId,
    required this.userName,
    required this.email,
    required this.password,
  });
  factory Account.fromJson(Map<String, dynamic> json)
  {
    return Account(
        acId: json['acId'] ?? 0,
        userName: json['userName'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
    );
  }
}