import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  late Users _userInfo; // 로그인 상태

  bool _loginStat = false;

  Users get userInfo => _userInfo;

  bool get isLogin => _loginStat; // 전역변수

  set userInfo(Users userInfo) {
    _userInfo = userInfo;
  }

  set loginStat(bool loginStat) {
    _loginStat = loginStat;
  }

  final Dio _dio = Dio();

  final storage = const FlutterSecureStorage();

  Future<void> login(String id, String password,
      {bool rememberId = false, bool rememberMe = false}) async {
    _loginStat = false;

    const url = 'http://10.0.2.2:8080/login';
    final data = {'id': id, 'password': password}; // ✅ 서버에서 id를 요구하는지 확인

    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json', // ✅ JSON 데이터 전송
            'Accept': 'application/json', // ✅ JSON 응답 기대
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ 로그인 성공!');

        // JWT 토큰 확인
        final authorization = response.headers['authorization']?.first;
        print('✅ 로그인 성공!');
        if (authorization == null) {
          print("❌ 로그인 실패: JWT 토큰 없음");
          return;
        }

        // JWT 토큰 저장
        final jwt = authorization.replaceFirst('Bearer ', '');
        await storage.write(key: 'jwt', value: jwt);

        // 사용자 정보 저장
        _userInfo = Users.fromMap(response.data);
        _loginStat = true;

        // 아이디 저장 여부 처리
        if (rememberId) {
          await storage.write(key: 'id', value: id);
        } else {
          await storage.delete(key: 'id');
        }

        // 자동 로그인 처리
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auto_login', rememberMe);
      } else if (response.statusCode == 403) {
        // ✅ 수정된 비교 방식
        print("❌ 로그인 실패: 아이디 또는 비밀번호 불일치");
      } else {
        print("❌ 로그인 실패: 알 수 없는 오류 (상태 코드: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 로그인 요청 중 오류 발생: $e");
    }

    // UI 업데이트
    notifyListeners();
  }

  // 사용자 정보 요청
  Future<bool> getUserInfo() async {
    final url = 'http://10.0.2.2:8080/user/info';
    try {
      String? jwt = await storage.read(key: 'jwt');
      final response = await _dio.get(url,
          options: Options(
              headers: {'Authorization': 'Bearer $jwt', 'Content-Type': 'application/json'}));
      if (response.statusCode == 200) {
        final userInfo = response.data;
        if (userInfo == null) {
          print("회원 정보가 존재하지 않습니다.");
          return false;
        }
        _userInfo = Users.fromMap(userInfo);
        notifyListeners();
        return true;
      } else {
        print("사용자 정보 조회 실패");
        return false;
      }
    } catch (e) {
      print("사용자 정보 요청 실패 : $e");
      return false;
    }
  }

  // 자동 로그인 처리
  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('auto_login') ?? false;
    if (rememberMe) {
      final jwt = await storage.read(key: 'jwt');
      if (jwt != null) {
        // 사용자 정보 요청
        bool result = await getUserInfo();
        if (result) {
          _loginStat = true;
          notifyListeners();
        }
      }
    }
  }

  // 로그아웃처리
  Future<void> logout() async {
    try {
      // jwt 토큰 삭제
      await storage.delete(key: 'jwt');
      // 사용자 정보 초기화
      _userInfo = Users();
      // 로그인 상태 초기화
      _loginStat = false;
      // 아이디 저장, 자동 로그인 여부 삭제
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('auto_login');
      print("로그아웃 성공");
    } catch (e) {
      print("로그아웃 실패 : $e");
    }
    notifyListeners();
  }
}
