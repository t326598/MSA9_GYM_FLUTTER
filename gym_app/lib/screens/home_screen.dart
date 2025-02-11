import 'dart:async';

import 'package:flutter/material.dart';
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
  int _counter = 60; // 유효시간을 60초
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    qrCodeData = generateQRCodeData(); // 초기 QR 코드 데이터 생성
  }

  String generateQRCodeData() {
    String uniqueId = uuid.v4();  // 고유한 UUID 생성
    return 'https://example.com/?userNo=12345&timestamp=${DateTime.now().millisecondsSinceEpoch}&uuid=$uniqueId';
  }

  void _startTimer() {
    setState(() {
      _counter = 60; // 카운트다운 초기화
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--; // 카운트다운
        });
      } else {
        _timer.cancel(); // 타이머 종료
      }
    });
  }

  @override
  void dispose() {
    // 페이지를 떠날 때 타이머 취소
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
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
              'img/main.png',
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
                const Text(
                  '10명',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 125,
            child: Image.asset(
              'img/icon.png',
              height: 190,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(80.0),
              child: ElevatedButton(
                onPressed: () {
                  _startTimer(); // 버튼을 눌렀을 때 타이머 시작
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return Container(
                            decoration: BoxDecoration(
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
                                QrImageView(
                                  data: qrCodeData,
                                  version: QrVersions.auto,
                                  size: 300.0,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '유효시간 : $_counter초',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
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
    );
  }
}
