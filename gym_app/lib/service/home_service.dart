import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeService {
  final String baseUrl = 'http://10.0.2.2:8080';  //서버 주소


  Future<int> getUserCount() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/attendance/userCount'));

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      return data['userCount'] ?? 0;  
    } else {
      throw Exception('Failed to load user count');
    }
  }
}
