import 'package:flutter/material.dart';
import 'package:gym_app/screens/ticket_screen.dart';
import 'package:gym_app/service/trainer_service.dart';
import 'package:gym_app/widgets/bottom_sheet.dart';
import 'package:gym_app/widgets/ticket_card.dart';

class PtTicketScreen extends StatefulWidget {
  const PtTicketScreen({super.key});

  @override
  State<PtTicketScreen> createState() => _PtTicketScreenState();
}

class _PtTicketScreenState extends State<PtTicketScreen> {
  bool isGeneralActive = false;
  bool isPtActive = true;
  int _currentIndex = 1;
  Map<String, dynamic>? trainerProfile;
  final TrainerService _trainerService = TrainerService();

  final List<String> routes = [
    '/home',
    '/ticket',
    '/reservationInsert',
    '/calendar',
    '/myPage'
  ];

  Future<void> _loadTrainerProfile(int trainerNo) async {
    try {
      final profile = await _trainerService.getTrainerProfile(trainerNo);
      setState(() {
        trainerProfile = profile;
      });
    } catch (e) {
      print('트레이너 정보 조회 실패: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('no')) {
      final trainerNoValue = arguments['no'];
      print('전달된 trainerNo: $trainerNoValue');
      _loadTrainerProfile(trainerNoValue);
    } else {
      print('트레이너 번호가 전달되지 않았습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 47, 47),
        title: const Text(
          '이용권 구매',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 49, 47, 47),  // 전체 배경색을 변경
      body: Column(
        children: [
          trainerProfile == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 49, 47, 47), // 배경색 설정
                        child: ListTile(
                          dense: true, // 세로 길이를 더 줄이기 위해 dense 사용
                          contentPadding: EdgeInsets.zero,
                          leading: Image.network(
                            'http://10.0.2.2:8080/files/${trainerProfile!['fileNo']}/thumbnail',
                            width: 60,  // 이미지 크기
                            height: 60, // 이미지 크기
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            trainerProfile!['name'] ?? 'No Name',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trainerProfile!['simpleInfo'] ?? 'No Simple Info',
                                style: const TextStyle(fontSize: 14, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              // detailInfo에 배경 색상 추가
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 122, 135, 141), // 배경 색상
                                  borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                                ),
                                child: Text(
                                  trainerProfile!['detailInfo'] ?? 'No Detail Info',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white, // 텍스트 색상
                                    fontWeight: FontWeight.bold, // 글씨 진하게
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          const Expanded(child: TicketCard(type: 'PT')),
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
      bottomSheet: Container(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              ),
              SizedBox(
                width: 8,
              ),
              Text('구매하기'),
            ],
          ),
          tileColor: Colors.blueAccent,
          textColor: Colors.white,
          onTap: () {
            // 구매하기 버튼을 눌렀을 때 수행할 작업을 여기에 작성하세요.
            print('구매하기 버튼 클릭됨');
          },
        ),
      ),
    );
  }
}
