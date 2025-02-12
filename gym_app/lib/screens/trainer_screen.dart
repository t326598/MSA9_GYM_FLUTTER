import 'package:flutter/material.dart';
import 'package:gym_app/screens/ticket_screen.dart';
import 'package:gym_app/widgets/trainer_card.dart';
import 'package:gym_app/widgets/trainer_pofile.dart';

class TrainerScreen extends StatefulWidget {
  const TrainerScreen({super.key});

  @override
  State<TrainerScreen> createState() => _TrainerScreenState();
}

class _TrainerScreenState extends State<TrainerScreen> {
  bool isGeneralActive = false;
  bool isPtActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 47, 47),
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로 가기 버튼을 없앰
        backgroundColor: const Color.fromARGB(255, 49, 47, 47),
        title: const Text(
          '이용권 구매',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 0.2),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isGeneralActive = true;
                      isPtActive = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TicketScreen(),
                      ),
                    ).then((_) {
                      // TicketScreen에서 돌아올 때 상태 업데이트
                      setState(() {
                        isGeneralActive = false;
                        isPtActive = true;
                      });
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isGeneralActive
                        ? Colors.blue // 활성화된 상태
                        : Colors.transparent, // 비활성화된 상태
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Text(
                    '일반 이용권',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 0.2),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isGeneralActive = false;
                      isPtActive = true;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isPtActive
                        ? Colors.blue // 활성화된 상태
                        : Colors.transparent, // 비활성화된 상태
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Text(
                    'PT 이용권',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          child: Column(
            children: [
              Wrap(
                spacing: 10, // 가로 간격
                runSpacing: 10, // 세로 간격 (줄바꿈 시)
                alignment: WrapAlignment.center, // 중앙 정렬
                children: [TrainerProfile()],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
