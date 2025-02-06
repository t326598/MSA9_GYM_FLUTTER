import 'package:flutter/material.dart';
import 'package:gym_app/screens/ticket_screen.dart';
import 'package:gym_app/screens/trainer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '네비게이션 위젯',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/ticket',
      routes: {
        '/ticket': (context) => TicketScreen(),
        '/trainer': (context) => TrainerScreen(),
      },
    );
  }
}
