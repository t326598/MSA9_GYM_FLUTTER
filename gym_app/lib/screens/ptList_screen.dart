import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PtlistScreen extends StatefulWidget {
  const PtlistScreen({super.key});

  @override
  State<PtlistScreen> createState() => _PtlistScreenState();
}

class _PtlistScreenState extends State<PtlistScreen> {
  final List<Map<String, String>> reservations = [
    {'trainer': '조한욱 트레이너', 'date': '2024-12-16 10:00', 'status': '예약됨'},
    {'trainer': '조한욱 트레이너', 'date': '2024-12-21 21:00', 'status': '예약됨'},
    {'trainer': '조한욱 트레이너', 'date': '2024-12-22 12:00', 'status': '완료'},
    {'trainer': '홍성운 트레이너', 'date': '2025-01-19 13:00', 'status': '취소됨'},
  ];

  int completedPT = 6;
  int remainingPT = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 목록', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('완료 PT 횟수: $completedPT',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                      Text('남은 PT 횟수: $remainingPT',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 이용권 구매 페이지로 이동하는 기능 추가 필요
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      '이용권 구매',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '삭제',
                        flex: 4,
                      ),
                    ],
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text(reservation['trainer']!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(reservation['date']!),
                      trailing: Text(
                        reservation['status']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: reservation['status'] == '완료' ? Colors.green :
                                 reservation['status'] == '취소됨' ? Colors.red : Colors.orange,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
