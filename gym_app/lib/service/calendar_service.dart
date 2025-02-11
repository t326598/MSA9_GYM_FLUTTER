import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gym_app/models/calendar_response.dart';

class CalendarService {
  final Dio _dio = Dio();
  final String host = 'http://10.0.2.2:8080';

  Future<CalendarResponse?> getPlans() async {
    try {
      // final storage = const FlutterSecureStorage();
      // String? jwt = await storage.read(key: 'jwt');
      // if (jwt == null) {
      //   return null;
      // }
      final response = await _dio.get(
        '$host/user/schedule',
        options: Options(
          headers: {
            'Authorization':
                'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3Mzk4NDA1ODIsImlkIjoiam9ldW4iLCJ1c2VyTm8iOjEsInJvbCI6WyJST0xFX1VTRVIiXX0.q_t4bTgVj_Zjr58LIDwGF8_mMHEF6qpn_hdSYHn5aVI9J1i-89D2Ly13bpY7XNlTJTzVpidNE7rEBOlAJupAIA',
            // 'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('이벤트 목록 조회 성공!');
        print(response.data);
        return CalendarResponse.fromJson(response.data);
      }
    } catch (e) {
      print('getPlans Error : $e');
    }
    return null;
  }
}
// 여기 로그인한 상태의 요청으로 바꾸기
// 예전 프로젝트, login_application
