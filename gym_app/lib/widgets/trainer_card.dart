import 'package:flutter/material.dart';
import 'package:gym_app/service/trainer_service.dart';

class TrainerCard extends StatefulWidget {
  const TrainerCard({super.key});

  @override
  State<TrainerCard> createState() => _TrainerCardState();
}

class _TrainerCardState extends State<TrainerCard> {
  List<Map<String, dynamic>> trainers = [];

  @override
  void initState() {
    super.initState();
    _loadTrainer();
  }

  // 트레이너 정보 가져오는 메서드
  Future<void> _loadTrainer() async {
    try {
      TrainerService trainerService = TrainerService();
      List<Map<String, dynamic>> fetchedTrainers =
          await trainerService.getTrainer(); // 트레이너 목록 가져오기

      setState(() {
        trainers = fetchedTrainers; // 상태 업데이트
      });
    } catch (e) {
      print('트레이너 정보 조회 중 오류 : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (trainers.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      // Scroll 가능하도록 SingleChildScrollView로 감싸기
      child: Column(
        children: [
          Wrap(
            spacing: 10, // 가로 간격
            runSpacing: 10, // 세로 간격 (줄바꿈 시)
            alignment: WrapAlignment.center, // 중앙 정렬
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 한 줄에 2개씩 배치
                  crossAxisSpacing: 10, // 가로 간격
                  mainAxisSpacing: 10, // 세로 간격
                  childAspectRatio: 0.74, // 카드의 가로세로 비율 조정
                ),
                physics: NeverScrollableScrollPhysics(), // GridView의 스크롤 방지
                shrinkWrap: true, // GridView 크기 조정
                itemCount: trainers.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> trainer = trainers[index];
                  int trainerFileNo = trainer['fileNo'];

                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.network(
                          'http://10.0.2.2:8080/files/$trainerFileNo/thumbnail', // 트레이너 이미지 URL 적용
                          width: 170,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: 170,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                trainer['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 30,
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/ptTicket',
                                      arguments: {'no': trainer['no']},
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.green,
                                    side: BorderSide(
                                      color: Colors.lightGreen,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    '선택',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
