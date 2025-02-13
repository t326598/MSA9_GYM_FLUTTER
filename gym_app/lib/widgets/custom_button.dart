import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final isFullWidth;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isFullWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth == true ? double.infinity : null,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // 글자 색상
            backgroundColor: Colors.blue, // 버튼 배경 색상
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: Text(text)),
    );
  }
}
