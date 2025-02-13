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

// 🔥 서버에서 받아온 JSON 데이터를 Users 객체로 변환
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      no: json['no'] as int?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      birth: json['birth'] as String?,
      enabled: json['enabled'] as int?,
      trainerNo: json['trainerNo'] as int?,
    );
  }

  // 🔥 Users 객체를 JSON으로 변환 (회원 수정 시 사용 가능)
  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'birth': birth,
      'enabled': enabled,
      'trainerNo': trainerNo,
      'authList': authList,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      no: map['no'],
      id: map['id'],
      password: map['password'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      birth: map['birth'],
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
