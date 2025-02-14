import 'package:http/http.dart' as http;

Future<void> saveUserToServer(String userId, String nickname, String email) async {
  final url = 'https://your-api-url.com/save_user'; // 실제 서버 URL로 교체
  final response = await http.post(url as Uri, body: {
    'user_id': userId,
    'nickname': nickname,
    'email': email,
  });

  if (response.statusCode == 200) {
    print('User data saved successfully!');
  } else {
    print('Failed to save user data.');
  }
}
