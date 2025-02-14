import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class TicketListService {
  final String baseUrl = 'http://10.0.2.2:8080'; // 기본 서버 URL 설정
  final Dio _dio = Dio();
  // 유저 번호에 맞는 구매 내역 가져오기
  Future<Map<String, dynamic>> getBuyList(int userNo) async {
    final response = await _dio.get('$baseUrl/buyList/users/$userNo');
    print(response.data);
    if (response.statusCode == 200) {
      return response.data; // 응답 바디를 Map으로 파싱
    } else {
      throw Exception('이용권 내역을 가져오는 데 실패했습니다');
    }
  }

  Future<Map<String, dynamic>> getTicketDate() async {
    final response = await _dio.get('$baseUrl/user/ticketDate');
    print(response.data);
    print('response.date : ${response.data}');
    if (response.statusCode == 200) {
      return response.data; // 응답 바디를 Map으로 파싱
    } else {
      throw Exception('이용권 내역을 가져오는 데 실패했습니다');
    }
  }
}
