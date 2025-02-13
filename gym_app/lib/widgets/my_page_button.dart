import 'package:flutter/material.dart';

class MyPageButton extends StatelessWidget {
  final String title; // 🔹 버튼 제목
  final VoidCallback onPressed; // 🔹 클릭 시 실행할 함수

  const MyPageButton({
    super.key,
    required this.title,
    required this.onPressed, // ✅ required 키워드 추가해야 오류 없음
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // ✅ 클릭 시 동작
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size(double.infinity, 50.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
      ),
      child: Text(
        title, // ✅ 전달된 title 사용
        style: const TextStyle(fontSize: 30),
      ),
    );
  }
}
