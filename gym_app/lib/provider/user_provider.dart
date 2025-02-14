import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  Users? _userInfo; // ✅ nullable로 변경하여 초기화 오류 방지
  bool _loginStat = false;

  Users? get userInfo => _userInfo; // ✅ null 가능성 처리

  bool get isLogin => _loginStat;

  final Dio _dio = Dio();
  final storage = const FlutterSecureStorage();

  int? get userNo => _userInfo?.no; // 유저 no 가져오기

  Future<void> login(String id, String password,
      {bool rememberId = false, bool rememberMe = false}) async {
    _loginStat = false;
    const url = 'http://10.0.2.2:8080/login';
    final data = {'id': id, 'password': password};

    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final authorization = response.headers['authorization']?.first;
        if (authorization == null) {
          print("❌ 로그인 실패: JWT 토큰 없음");
          return;
        }

        final jwt = authorization.replaceFirst('Bearer ', '');
        await storage.write(key: 'jwt', value: jwt);

        // 🔥 사용자 정보 저장 (fromMap 사용)
        _userInfo = Users.fromMap(response.data);
        _loginStat = true;

        if (rememberId) {
          await storage.write(key: 'id', value: id);
        } else {
          await storage.delete(key: 'id');
        }

        if (rememberMe) {
          print("자동 로그인");
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('auto_login', true);
        } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('auto_login', false);
        }
      } else if (response.statusCode == 403) {
        print("아이디 또는 비밀번호가 일치하지 않습니다.");
      } else {
        print("알수 없는 오류로 로그인에 실패하였습니다.");
      }
    } catch (e) {
      print("로그인 실패");
    }

    notifyListeners();
  }

  /// 🔥 **사용자 정보 요청 (한 번만 호출되도록 개선)**
  Future<bool> getUserInfo() async {
    if (_userInfo != null) return true; // ✅ 이미 로드된 경우 추가 요청 방지

    final url = 'http://10.0.2.2:8080/user/info';
    try {
      String? jwt = await storage.read(key: 'jwt');
      final response = await _dio.get(
        url,
        options:
            Options(headers: {'Authorization': 'Bearer $jwt', 'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final userData = response.data;
        if (userData == null) {
          print("회원 정보가 존재하지 않습니다.");
          return false;
        }

        final newUserInfo = Users.fromMap(userData);
        if (_userInfo != newUserInfo) {
          _userInfo = newUserInfo;
          notifyListeners(); // 🔥 변경이 있을 때만 UI 업데이트
        }

        return true;
      } else {
        print("사용자 정보 조회 실패");
        return false;
      }
    } catch (e) {
      print("사용자 정보 요청 실패: $e");
      return false;
    }
  }

  /// 🔥 **자동 로그인 처리 (사용자 정보 유지)**
  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('auto_login') ?? false;
    if (rememberMe) {
      final jwt = await storage.read(key: 'jwt');
      if (jwt != null) {
        bool result = await getUserInfo(); // 🔥 사용자 정보 요청
        if (result) {
          _loginStat = true;
          notifyListeners();
        }
      }
    }
  }

  /// 🔥 **로그아웃 처리**
  Future<void> logout() async {
    try {
      await storage.delete(key: 'jwt');
      final prefs = await SharedPreferences.getInstance();

      prefs.remove('auto_login');
      _userInfo = null; // ✅ 로그아웃 시 사용자 정보 초기화
      _loginStat = false;
      notifyListeners();
      print("로그아웃 성공");
    } catch (e) {
      print("로그아웃 실패: $e");
    }
  }
}
