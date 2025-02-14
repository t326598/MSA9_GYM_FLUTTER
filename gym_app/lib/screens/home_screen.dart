import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_app/service/home_service.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_sheet.dart';
import '../provider/user_provider.dart'; // ✅ 추가

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final Uuid uuid = Uuid();
  String qrCodeData = '';
  int _currentIndex = 0;
  final HomeService homeService = HomeService();
  final List<String> routes = [
    '/home',
    '/ticket',
    '/reservationInsert',
    '/calendar',
    '/myPage'
  ];

  @override
  void initState() {
    super.initState();
    qrCodeData = generateQRCodeData();
  }

  String generateQRCodeData() {
    String uniqueId = uuid.v4();
    return 'http://10.0.2.2:8080/checkAttendance?userNo=12345&timestamp=${DateTime.now().millisecondsSinceEpoch}&uuid=$uniqueId';
  }

  Future<int> fetchGymUserCount() async {
    try {
      final count = await homeService.getUserCount();
      return count;
    } catch (e) {
      print('Error fetching user count: $e');
      return 0;
    }
  }

  void _showQRCodeModal(BuildContext context) {
    int _counter = 60;
    Timer? _timer;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
              if (_counter > 0) {
                setModalState(() {
                  _counter--;
                });
              } else {
                _timer?.cancel();
                Navigator.pop(context);
              }
            });

            return WillPopScope(
              onWillPop: () async {
                _timer?.cancel();
                return true;
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_counter > 0)
                      QrImageView(
                        data: qrCodeData,
                        version: QrVersions.auto,
                        size: 300.0,
                      ),
                    const SizedBox(height: 10),
                    if (_counter > 0)
                      Text(
                        '유효시간 : $_counter초',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _timer?.cancel();
    });
  }

  // SnackBar를 반환하는 함수
  SnackBar customSnackbar() {
    return const SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text("로그인이 필요한 기능입니다."),
        ],
      ),
      backgroundColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 49, 47, 47),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 206, 61, 61),
          onPrimary: Color.fromARGB(255, 241, 239, 239),
          surface: Color.fromARGB(255, 178, 10, 201),
          onSurface: Color.fromARGB(255, 9, 191, 211),
        ),
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
              child: Image.asset(
                'images/main.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '실시간 헬스장 이용자 수',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<int>(
                    future: fetchGymUserCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        int gymUserCount = snapshot.data ?? 0;
                        String statusMessage = '';
                        Color statusColor = Colors.transparent;

                        if (gymUserCount < 10) {
                          statusMessage = '여유';
                          statusColor = Colors.green;
                        } else if (gymUserCount < 20) {
                          statusMessage = '혼잡';
                          statusColor = Colors.yellow;
                        } else {
                          statusMessage = '포화';
                          statusColor = Colors.red;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$gymUserCount명  /',
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                statusMessage,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'images/logo.png',
                    height: 100,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return ElevatedButton(
                      onPressed: () {
                        if (userProvider.isLogin) {
                          _showQRCodeModal(context);
                        } else {
                          // SnackBar 알림을 띄우고 로그인 화면으로 이동
                          ScaffoldMessenger.of(context)
                              .showSnackBar(customSnackbar());
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pushNamed(context, '/login');
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 88, 72, 90),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.qr_code,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '헬스장 입장',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            if (index >= 0 && index < routes.length) {
              Navigator.pushReplacementNamed(context, routes[index]);
            }
          },
        ),
      ),
    );
  }
}
