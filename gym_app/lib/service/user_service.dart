import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final Dio _dio = Dio();
  final String host = 'http://10.0.2.2:8080';
  // 회원가입
  Future<bool> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('$host/user', data: userData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> findPw(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('$host/findPw', data: userData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

// 회원정보 조회
  Future<Map<String, dynamic>> getUser(String? id) async {
    if (id == null) {
      return {};
    }
    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: "jwt");
      final response = await _dio.get('$host/user/info',
          options: Options(headers: {'Authorization': 'Bearer $jwt'}));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      print("회원 정보 조회 요청 시, 에러 발생: $e");
    }
    return {};
  }

  Future<bool> checkId(String? id) async {
    if (id == null) {
      return false;
    }
    final response = await _dio.get('$host/check/$id');
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

// 회원정보 수정
  Future<bool> updateUser(Map<String, dynamic> userData) async {
    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: "jwt");

      final response = await _dio.put('$host/user',
          data: userData, options: Options(headers: {'Authorization': 'Bearer $jwt'}));
      if (response.statusCode == 200) {
        print("회원정보  수정");
        return true;
      } else {
        print("회원정보 수정 실패");
        return false;
      }
    } catch (e) {
      print("회원 정보 수정 요청 시, 에러 발생: $e");
      return false;
    }
  }

// 회원정보 삭제
  Future<bool> deleteUser(int? no) async {
    if (no == null) {
      return false;
    }
    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: "jwt");
      final response = await _dio.delete('$host/user/$no',
          options: Options(
              headers: {'Authorization': 'Bearer $jwt', 'Context-Type': 'application/json'}));
      if (response.statusCode == 200) {
        print("회원 탈퇴 성공");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("회원 탈퇴 요청 시, 에러 발생: $e");
    }
    return false;
  }
}
