import 'package:flutter/material.dart';
import 'package:gym_app/service/trainer_service.dart';

class TrainerProfile extends StatefulWidget {
  @override
  _TrainerProfileState createState() => _TrainerProfileState();
}

class _TrainerProfileState extends State<TrainerProfile> {
  List<Map<String, dynamic>> trainers = [];
  bool isLoading = true;
  bool hasError = false;

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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator()); // 로딩 중
    }

    if (hasError) {
      return Center(child: Text('오류 발생')); // 오류 발생 시
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: trainers.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> trainer = trainers[index]; // 개별 트레이너 데이터
        int trainerFileNo = trainer['fileNo'];

        return Container(
          width: 170, // 고정된 가로 크기
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              // 트레이너 썸네일 이미지 가져오기
              FutureBuilder<String>(
                future: TrainerService().getThumbnail(trainer['fileNo']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('썸네일 로딩 실패'));
                  } else if (snapshot.hasData) {
                    return Image.network(
                      'http://10.0.2.2:8080/files/$trainerFileNo/thumbnail',
                      width: 170,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Center(child: Text('썸네일 없음'));
                  }
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 트레이너 이름 표시
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
                          print('${trainer['name']} 선택됨');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.green,
                          side: BorderSide(color: Colors.lightGreen, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          '선택',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
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
    );
  }
}
