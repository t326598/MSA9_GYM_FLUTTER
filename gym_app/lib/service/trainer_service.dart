import 'package:dio/dio.dart';
import 'dart:convert';

class TrainerService {
  final Dio _dio = Dio();
  final String host = 'http://10.0.2.2:8080';

  // 트레이너 목록 조회
  Future<List<Map<String, dynamic>>> getTrainer() async {
    try {
      final response = await _dio.get('$host/admin/trainer/list');

      if (response.statusCode == 200) {
        print('트레이너 목록 조회 성공!');
        return List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      print('트레이너 목록 조회 중 오류 발생 : $e');
    }
    return [];
  }

  // 트레이너 상세 조회
  Future<Map<String, dynamic>?> getTrainerProfile(int trainerNo) async {
    try {
      final response =
          await _dio.get('$host/admin/trainer/select?no=$trainerNo');
      print('서버 응답: ${response.data}');
      print('서버 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('트레이너 상세 조회 성공!');
        if (response.data is String) {
          return jsonDecode(response.data); // JSON 변환
        } else if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception('예상치 못한 응답 형식: ${response.data.runtimeType}');
        }
      } else {
        throw Exception('트레이너 상세 정보 로딩 실패');
      }
    } catch (e) {
      print('트레이너 상세 조회 중 오류 발생: $e');
    }
    return null;
  }
}
