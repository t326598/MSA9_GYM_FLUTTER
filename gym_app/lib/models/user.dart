import 'package:gym_app/models/auth.dart';

class Users {
  int? no;
  String? id;
  String? password;
  String? name;
  String? phone;
  String? email;
  String? birth;
  String? gender;
  int? enabled;
  int? trainerNo;
  String? code;
  String? question;
  String? answer;
  DateTime? createdAt;
  DateTime? updatedAt;

  String? userAuth;
  List<UserAuth>? authList;

  String? trainerName;

  Users(
      {this.no,
      this.id,
      this.password,
      this.name,
      this.phone,
      this.email,
      this.birth,
      this.gender,
      this.enabled,
      this.trainerNo,
      this.code,
      this.question,
      this.answer,
      this.createdAt,
      this.updatedAt,
      this.userAuth,
      this.authList = const [],
      this.trainerName});
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      no: map['no'],
      id: map['id'],
      password: map['password'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      createdAt:
          map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt']) : null,
      enabled: map['enabled'],
      authList: map['authList'] != null
          ? List<UserAuth>.from(map['authList'].map((auth) => UserAuth.fromMap(auth)))
          : [],
      trainerName: map['trainerName'],
    );
  }
}
