import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gym_app/models/calendar_response.dart';
import 'package:gym_app/models/comment.dart';

class CalendarService {
  final Dio _dio = Dio();
  final String host = 'http://10.0.2.2:8080';

  Future<CalendarResponse?> getPlans() async {
    try {
      // String? jwt =
      //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3Mzk5MjU4MzgsImlkIjoiam9ldW4iLCJ1c2VyTm8iOjEsInJvbCI6WyJST0xFX1VTRVIiXX0.Gko_kP81tKeephZwAi90K1RkHzlk691mXWNXkbTBG2MGXJXjOgr0x8BQJD6GT3bw4k0np69mPCo84rtLxZH8Ww';
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: 'jwt');
      if (jwt == null) {
        return null;
      }
      final response = await _dio.get(
        '$host/user/schedule',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
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

  Future<CalendarResponse?> getPlansByDate(DateTime selectedDate) async {
    try {
      // String? jwt =
      //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3Mzk5MjU4MzgsImlkIjoiam9ldW4iLCJ1c2VyTm8iOjEsInJvbCI6WyJST0xFX1VTRVIiXX0.Gko_kP81tKeephZwAi90K1RkHzlk691mXWNXkbTBG2MGXJXjOgr0x8BQJD6GT3bw4k0np69mPCo84rtLxZH8Ww';
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: 'jwt');
      if (jwt == null) {
        return null;
      }

      final year = selectedDate.year;
      final month = selectedDate.month;
      final day = selectedDate.day;

      print("selectedDate : $year/$month/$day");

      final response = await _dio.get(
        '$host/user/schedule/$year/$month/$day',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('이벤트 목록 날짜로 조회 성공!');
        print(response.data);
        return CalendarResponse.fromJson(response.data);
      }
    } catch (e) {
      print('getPlansByDate Error : $e');
    }
    return null;
  }

  Future<Comment?> getCommentByDate(DateTime selectedDate) async {
    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: 'jwt');
      if (jwt == null) {
        return null;
      }

      final year = selectedDate.year;
      final month = selectedDate.month;
      final day = selectedDate.day;

      print("selectedDate : $year/$month/$day");

      final response = await _dio.get(
        '$host/user/schedule/comment/$year/$month/$day',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('코멘트 날짜로 조회 성공!');
        debugPrint(response.data);
        return Comment.fromJson(response.data);
        // return null;
      }
    } catch (e) {
      print('getCommentByDate Error : $e');
    }
    return null;
  }

  // 일정 수정
  Future<bool> updatePlan(Map<String, dynamic> userData) async {
    try {
      // String? jwt =
      //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3Mzk5MjU4MzgsImlkIjoiam9ldW4iLCJ1c2VyTm8iOjEsInJvbCI6WyJST0xFX1VTRVIiXX0.Gko_kP81tKeephZwAi90K1RkHzlk691mXWNXkbTBG2MGXJXjOgr0x8BQJD6GT3bw4k0np69mPCo84rtLxZH8Ww';
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: 'jwt');
      if (jwt == null) {
        return false;
      }
      final response = await _dio.put(
        '$host/user/schedule',
        data: userData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('일정 수정 성공!');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("updatePlans error: $e");
      return false;
    }
  }

  // 일정 추가
  Future<bool> insertPlan(Map<String, dynamic> userData) async {
    try {
      // String? jwt =
      //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3Mzk5MjU4MzgsImlkIjoiam9ldW4iLCJ1c2VyTm8iOjEsInJvbCI6WyJST0xFX1VTRVIiXX0.Gko_kP81tKeephZwAi90K1RkHzlk691mXWNXkbTBG2MGXJXjOgr0x8BQJD6GT3bw4k0np69mPCo84rtLxZH8Ww';
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: 'jwt');
      if (jwt == null) {
        return false;
      }
      final response = await _dio.post(
        '$host/user/schedule',
        data: userData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('일정 추가 성공!');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("updatePlans error: $e");
      return false;
    }
  }

  /// 회원탈퇴
  Future<bool> deletePlan(int no) async {
    if (no.isNaN) {
      return false;
    }
    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: 'jwt');
      final response = await _dio.delete(
        '$host/user/schedule?no=$no',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('일정 삭제 성공!');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("일정 삭제 시, 에러발생: $e");
    }
    return false;
  }
}
// 여기 로그인한 상태의 요청으로 바꾸기
// 예전 프로젝트, login_application
