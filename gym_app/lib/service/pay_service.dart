import 'package:dio/dio.dart';

class PayService {
  final Dio _dio = Dio();
  final String host = 'http://10.0.2.2:8080';

  Future<bool> postBuyList(Map<String, dynamic> buyData) async {
    try {
      final response = await _dio.get('$host/user/pay/paying', data: buyData);

      if (response.statusCode == 200) {
        print('구매내역 등록 성공!');
        return true;
      }
      return false;
    } catch (e) {
      print('구매내역 등록  중 오류 발생 : $e');
      rethrow;
    }
  }
}
