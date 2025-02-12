import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_app/service/home_service.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/bottom_sheet.dart';

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
      return 0; // 에러 시 0명으로 반환
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
            if (_timer == null) {
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (_counter > 0) {
                  setModalState(() {
                    _counter--;
                  });
                } else {
                  _timer?.cancel();
                  Navigator.pop(context);
                }
              });
            }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 0),
                const Text(
                  '실시간 헬스장 이용자 수',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 10),

                // FutureBuilder를 사용하여 gymUserCount 비동기적으로 가져오기
                FutureBuilder<int>(
                  future: fetchGymUserCount(), // gymUserCount를 가져오는 비동기 함수 호출
                  builder: (context, snapshot) {
                    String statusMessage = '';
                    Color statusColor = Colors.transparent;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 데이터가 로딩 중일 때 로딩 표시
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // 에러 발생 시 에러 메시지 표시
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // 데이터가 정상적으로 로딩되었을 때 표시
                      int gymUserCount = snapshot.data!;

                      // 상태 메시지 설정
                      if (gymUserCount < 10) {
                        statusMessage = '여유';
                        statusColor = Colors.green;
                      } else if (gymUserCount >= 10 && gymUserCount < 20) {
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
                            '$gymUserCount명  /', // 서버에서 가져온 이용자 수 표시
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    } else {
                      return Text('No data available');
                    }
                  },
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'images/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 125,
            child: Image.asset(
              'images/icon.png',
              height: 190,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(80.0),
              child: ElevatedButton(
                onPressed: () => _showQRCodeModal(context),
                child: const Text(
                  '헬스장 입장 (QR)',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 175, 159, 179),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
            Navigator.pushNamed(context, routes[index]);
          }
        },
      ),
    );
  }
}
