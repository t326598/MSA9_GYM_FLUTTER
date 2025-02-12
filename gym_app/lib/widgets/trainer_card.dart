import 'package:flutter/material.dart';
import 'package:gym_app/service/trainer_service.dart';

class TrainerCard extends StatefulWidget {
  const TrainerCard({super.key});

  @override
  State<TrainerCard> createState() => _TrainerCardState();
}

class _TrainerCardState extends State<TrainerCard> {
  List<Map<String, dynamic>> trainers = [];

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
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Image(
            image: AssetImage("/images/jongguk.jpg"),
            width: 170,
            height: 200,
          ),
          Container(
            width: 170,
            padding:
                EdgeInsets.symmetric(horizontal: 8, vertical: 4), // 내부 여백 추가
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝 정렬
              children: [
                Text(
                  '김종국 트레이너',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white, // 텍스트 색상 변경
                  ),
                ),
                Container(
                  width: 40,
                  height: 30,
                  alignment: Alignment.center, // 내부 요소 정렬
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 내부 패딩 제거
                      backgroundColor: Colors.green,
                      side: BorderSide(
                          color: Colors.lightGreen, width: 2), // 테두리 추가
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
                      ),
                    ),
                    child: Text(
                      '선택',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center, // 텍스트 중앙 정렬
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
