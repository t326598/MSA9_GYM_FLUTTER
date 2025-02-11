import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_app/widgets/bottom_sheet.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final Uuid uuid = Uuid();
  String qrCodeData = '';
  int _currentIndex = 0;

  final List<String> routes = [
    '/home',
    '/ticket',
    '/trainer',
    '/reservationInsert',
    '/ptList',
    '/calendar',
  ];

  @override
  void initState() {
    super.initState();
    qrCodeData = generateQRCodeData();
  }

  String generateQRCodeData() {
    String uniqueId = uuid.v4();
    return 'https://example.com/?userNo=12345&timestamp=${DateTime.now().millisecondsSinceEpoch}&uuid=$uniqueId';
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
            // 모달이 열리면서 타이머 시작
            if (_timer == null) {
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (_counter > 0) {
                  setModalState(() {
                    _counter--; // UI 갱신
                  });
                } else {
                  _timer?.cancel();
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
                    // 60초 이후 QR 코드 숨기기
                    if (_counter > 0)
                      QrImageView(
                        data: qrCodeData,
                        version: QrVersions.auto,
                        size: 300.0,
                      ),
                    const SizedBox(height: 10),
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
      _timer?.cancel(); // 모달이 닫히면 타이머 정리
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
              children: const [
                SizedBox(height: 0),
                Text(
                  '실시간 헬스장 이용자 수',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '10명',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0,
                  ),
                ),
                SizedBox(height: 150),
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
