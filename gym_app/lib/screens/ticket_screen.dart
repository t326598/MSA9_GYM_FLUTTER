import 'package:flutter/material.dart';
import 'package:gym_app/screens/trainer_screen.dart';
import 'package:gym_app/service/ticket_service.dart';
import 'package:gym_app/widgets/bottom_sheet.dart';
import 'package:gym_app/widgets/ticket_card.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  bool isGeneralActive = true;
  bool isPtActive = false;
  int _currentIndex = 1;

  final List<String> routes = [
    '/home',
    '/ticket',
    '/trainer',
    '/reservationInsert',
    '/ptList',
    '/calendar',
  ];

  @override
  Widget build(BuildContext context) {
    TicketService ticketService = TicketService();

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
      body: Column(
        children: [
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrainerScreen(),
                        ),
                      ).then((_) {
                        // PtTicketScreen에서 돌아올 때 상태 업데이트
                        setState(() {
                          isGeneralActive = true;
                          isPtActive = false;
                        });
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
          Expanded(child: TicketCard()),
          SizedBox(
            height: 42,
          ),
        ],
      ),
      bottomSheet: Container(
        child: ListTile(
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              ),
              SizedBox(
                width: 8,
              ),
              Text('구매하기'),
            ]),
            tileColor: Colors.blueAccent,
            textColor: Colors.white,
            onTap: () {}),
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
