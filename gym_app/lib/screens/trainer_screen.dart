import 'package:flutter/material.dart';
import 'package:gym_app/screens/ticket_screen.dart';

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
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Image(
                            image: AssetImage('images/jongguk.jpg'),
                            width: 170,
                            height: 200,
                          ),
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4), // 내부 여백 추가
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween, // 양 끝 정렬
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
                                          color: Colors.lightGreen,
                                          width: 2), // 테두리 추가
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8), // 버튼 모서리 둥글게
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
                        ])),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(children: [
                        Image(
                          image: AssetImage('images/egg.jpg'),
                          width: 170,
                          height: 200,
                        ),
                        Container(
                          width: 170,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4), // 내부 여백 추가
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween, // 양 끝 정렬
                            children: [
                              Text(
                                '김계란 트레이너',
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
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/ptTicket');
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero, // 내부 패딩 제거
                                    backgroundColor: Colors.green,
                                    side: BorderSide(
                                        color: Colors.lightGreen,
                                        width: 2), // 테두리 추가
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // 버튼 모서리 둥글게
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
                      ]),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
