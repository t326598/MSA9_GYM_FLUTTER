import 'dart:convert';

class Reservation {
  int? no;
  int? userNo;
  int? trainerNo;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? enabled;

  String? userName;
  String? userId;
  String? trainerName;
  int? count;
  int? ptCount;

  Reservation({
    this.no,
    this.userNo,
    this.trainerNo,
    this.createdAt,
    this.updatedAt,
    this.enabled,
    this.userName,
    this.userId,
    this.trainerName,
    this.count,
    this.ptCount,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      no: json['no'],
      userNo: json['userNo'],
      trainerNo: json['trainerNo'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      enabled: json['enabled'] == 1,
      userName: json['userName'],
      userId: json['userId'],
      trainerName: json['trainerName'],
      count: json['count'],
      ptCount: json['ptCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'userNo': userNo,
      'trainerNo': trainerNo,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'enabled': enabled == true ? 1 : 0,
      'userName': userName,
      'userId': userId,
      'trainerName': trainerName,
      'count': count,
      'ptCount': ptCount,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
