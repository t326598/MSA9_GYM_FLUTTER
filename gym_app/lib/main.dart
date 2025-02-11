import 'package:flutter/material.dart';
import 'package:gym_app/screens/calendar_screen.dart';
import 'package:gym_app/screens/home_screen.dart';
import 'package:gym_app/screens/ptList_screen.dart';
import 'package:gym_app/screens/ptTicket_screen.dart';
import 'package:gym_app/screens/reservation_insert_screen.dart';
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

      initialRoute: '/home',


      routes: {
        '/home': (context) => HomeContent(),
        '/ticket': (context) => TicketScreen(),
        '/trainer': (context) => TrainerScreen(),
        '/reservationInsert': (context) => ReservationInsertScreen(),
        '/ptList': (context) => PtlistScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/ptTicket': (context) => PtTicketScreen(),
      },
    );
  }
}
