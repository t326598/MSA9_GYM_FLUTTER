import 'package:dio/dio.dart';

class TicketService {
  final Dio _dio = Dio();
  final String host = 'http://10.0.2.2:8080';

  Future<List<Map<String, dynamic>>> getTicket() async {
    try {
      final response = await _dio.get('$host/admin/ticket/list');

      if (response.statusCode == 200) {
        print('티켓 목록 조회 성공!');
        print(response.data);

        // List<dynamic> 데이터를 List<Map<String, dynamic>>로 변환
        List<Map<String, dynamic>> tickets =
            List<Map<String, dynamic>>.from(response.data);
        return tickets;
      }
    } catch (e) {
      print('티켓 조회 중 오류 발생 : $e');
    }
    return [];
  }
}
