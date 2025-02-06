import 'package:flutter/material.dart';

class PtTicketScreen extends StatelessWidget {
  const PtTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PT 이용권'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PT 이용권 화면',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                // PtTicketScreen에서 돌아갈 때 이전 화면으로 pop
                Navigator.pop(context);
              },
              child: const Text('뒤로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}
