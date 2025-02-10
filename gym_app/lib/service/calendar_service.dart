import 'package:dio/dio.dart';

class CalendarService {
  final Dio _dio = Dio();
  final String host = 'http://10.0.2.2:8080';

  Future<List<Map<String, dynamic>>> getPlans(String? username) async {
    if (username == null) {
      return [];
    }
    try {
      final response = await _dio.get('$host/user/schedule');

      if (response.statusCode == 200) {
        print('이벤트 목록 조회 성공!');
        print(response.data);
        return response.data;
      }
    } catch (e) {
      print('getPlans Error : $e');
    }
    return [];
  }
}
// 여기 로그인한 상태의 요청으로 바꾸기
// 예전 프로젝트, login_application
