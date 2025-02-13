import 'package:flutter/material.dart';
import 'package:gym_app/provider/user_provider.dart';
import 'package:gym_app/screens/calendar_screen.dart';
import 'package:gym_app/screens/find_id_screen.dart';
import 'package:gym_app/screens/find_pw_screen.dart';
import 'package:gym_app/screens/home_screen.dart';
import 'package:gym_app/screens/join.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/screens/my_page.dart';
import 'package:gym_app/screens/my_page_info.dart';
import 'package:gym_app/screens/ptList_screen.dart';
import 'package:gym_app/screens/ptTicket_screen.dart';
import 'package:gym_app/screens/reservation_insert_screen.dart';
import 'package:gym_app/screens/ticket_screen.dart';
import 'package:gym_app/screens/trainer_screen.dart';
import 'package:provider/provider.dart';

//  메인 수정했을지도?
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ 필수!
  final userProvider = UserProvider();
  await userProvider.autoLogin();

  runApp(ChangeNotifierProvider(
    // Provider
    // -ChangeNotifierProvider를 사용하여 UserProvider를 전역으로 사용
    create: (context) => UserProvider(),
    child: const MyApp(),
  ));
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
        '/login': (context) => Login(),
        '/join': (context) => Join(),
        '/findId': (context) => FindIdScreen(),
        '/findPw': (context) => FindPwScreen(),
        '/myPage': (context) => MyPage(),
        '/myPageInfo': (context) => MyPageInfo()
      },
    );
  }
}
