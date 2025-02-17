import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gym_app/models/reservation.dart';
import 'package:gym_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ReservationService {
  final Dio _dio = Dio();
  final String host = 'http://10.0.2.2:8080';

  Future<List<Reservation>?> getReservationsList() async {
  try {
    final storage = const FlutterSecureStorage();
    String? jwt = await storage.read(key: "jwt");
    String? userNoString = await storage.read(key: "userNo");

    print("📌 Storage에서 가져온 userNo (Raw): $userNoString");

    int? userNo = userNoString != null ? int.tryParse(userNoString) : null;
    print("📌 변환된 userNo: $userNo");

    if (jwt == null || userNo == null) {
      print("🚨 JWT 또는 userNo가 없음");
      return null;
    }

    final response = await _dio.get(
      '$host/user/myPage/ptList/$userNo',
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
      ),
    );

    print("📌 서버 응답 코드: ${response.statusCode}");

    if (response.statusCode == 200) {
      print('✅ 예약 목록 조회 성공!');
      Map<String, dynamic> data = response.data;
      List<dynamic> reservationList = data['reservationList'] ?? [];
      return reservationList.map((item) => Reservation.fromJson(item)).toList();
    }
  } catch (e) {
    print('🚨 예약 목록 조회 중 오류 발생: $e');
  }
  return null;
}

  Future<bool> createReservation(Map<String, dynamic> reservationData) async {
    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: "jwt");
      if (jwt == null) {
        return false;
      }
      final response = await _dio.post(
        '$host/user/reservation/reservationInsert',
        data: reservationData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('예약 생성 중 오류 발생: $e');
      return false;
    }
  }

  Future<bool> updateReservation(Reservation reservation, Map<String, dynamic> updatedData) async {
    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: "jwt");
      if (jwt == null) {
        return false;
      }
      final response = await _dio.put(
        '$host/user/myPage/ptList/\$reservationId',
        data: updatedData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('예약 수정 중 오류 발생: $e');
      return false;
    }
  }
}
