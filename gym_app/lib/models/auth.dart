class UserAuth {
  int? no;
  int? userNo;
  String? auth;

  UserAuth({this.no, this.userNo, this.auth});

  Map<String, dynamic> toMap() {
    return {'no': no, 'userNo': userNo, 'auth': auth};
  }

  factory UserAuth.fromMap(Map<String, dynamic> map) {
    return UserAuth(
      no: map['no'],
      userNo: map['userNo'],
      auth: map['auth'],
    );
  }
}
