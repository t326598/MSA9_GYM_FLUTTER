import 'package:dio/dio.dart';

class TrainerService {
  final Dio _dio = Dio();
  final String host = 'http://10.0.2.2:8080';

  // 트레이너 목록 조회
  Future<List<Map<String, dynamic>>> getTrainer() async {
    try {
      final response = await _dio.get('$host/admin/trainer/list');

      if (response.statusCode == 200) {
        print('트레이너 목록 조회 성공!');
        List<Map<String, dynamic>> trainers =
            List<Map<String, dynamic>>.from(response.data);
        return trainers;
      }
    } catch (e) {
      print('트레이너 목록 조회 중 오류 발생 : $e');
    }
    return [];
  }

  Future<String> getThumbnail(int fileNo) async {
    try {
      final response = await _dio.get('$host/files/$fileNo/thumbnail');

      if (response.statusCode == 200) {
        // 썸네일 URL을 반환
        return response.data.toString(); // 썸네일 이미지 URL
      } else {
        throw Exception('썸네일 로딩 실패');
      }
    } catch (e) {
      throw Exception('썸네일 로딩 중 오류 발생: $e');
    }
  }
}
