class AccountShow
{

  int acId;
  String userName;
  String email;

  AccountShow({
    required this.acId,
    required this.userName,
    required this.email
  });
  factory AccountShow.fromJson(Map<String, dynamic> json)
  {
    return AccountShow(
        acId: json['acId'] ?? 0,
        userName: json['userName'] ?? '',
        email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acId': acId,
      'userName': userName,
      'email': email,
    };
  }
}