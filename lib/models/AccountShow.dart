class AccountShow
{

  int acId;
  String userName;

  AccountShow({
    required this.acId,
    required this.userName
  });
  factory AccountShow.fromJson(Map<String, dynamic> json)
  {
    return AccountShow(
        acId: json['acId'] ?? 0,
        userName: json['userName'] ?? '',
    );
  }
}