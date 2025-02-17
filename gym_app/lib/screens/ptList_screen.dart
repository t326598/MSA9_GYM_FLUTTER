import 'package:flutter/material.dart';
import 'package:gym_app/models/reservation.dart';
import 'package:gym_app/service/reservation_service.dart';

class PtlistScreen extends StatefulWidget {
  const PtlistScreen({super.key});

  @override
  State<PtlistScreen> createState() => _PtlistScreenState();
}

class _PtlistScreenState extends State<PtlistScreen> {
  int completedPT = 6;
  int remainingPT = 24;

  List<Reservation> reservations = [];
  ReservationService reservationService = ReservationService();

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  void _fetchReservations() async {
    final response = await reservationService.getReservationsList();
    if (response != null) {
      setState(() {
        reservations = response;
      });
    }
  }

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
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(reservation.trainerName ?? '알 수 없음', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(reservation.createdAt?.toLocal().toString() ?? '날짜 없음'),
                    trailing: Text(
                      reservation.enabled == true ? '예약됨' : '취소됨',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: reservation.enabled == true ? Colors.orange : Colors.red,
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
