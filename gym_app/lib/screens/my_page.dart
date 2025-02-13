import 'package:flutter/material.dart';
import 'package:gym_app/provider/user_provider.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/widgets/my_page_button.dart'; // ✅ MyPageButton을 import

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = UserProvider();

    SnackBar customSnackbar() {
      return SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text("로그아웃 되었습니다."),
          ],
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 47, 47),
        foregroundColor: Colors.white,
        title: const Text("마이페이지"),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 49, 47, 47)),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Image(
              image: AssetImage('images/logo.png'),
              height: 100,
            ),
            const SizedBox(height: 20), // 버튼 간 간격
            MyPageButton(
              title: "내 정보",
              onPressed: () {
                Navigator.pushNamed(context, "/myPageInfo");
              },
            ),
            const SizedBox(height: 20),
            MyPageButton(
              title: "이용권 내역",
              onPressed: () {
                print("이용권 내역 클릭됨");
              },
            ),
            const SizedBox(height: 20),
            MyPageButton(
              title: "예약 내역",
              onPressed: () {
                print("예약 내역 클릭됨");
              },
            ),
            const SizedBox(height: 20),
            MyPageButton(
              title: "로그아웃",
              onPressed: () {
                userProvider.logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()), // 로그인 페이지로 이동
                  (route) => false, // 모든 기존 페이지 제거
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackbar(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
