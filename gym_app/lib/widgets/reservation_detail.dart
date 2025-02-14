import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showReservationDetail(BuildContext context, NeatCleanCalendarEvent event) {
  showMaterialModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 49, 47, 47),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
      ),
      builder: (context) => ReservationDetail(event: event));
}

class ReservationDetail extends StatelessWidget {
  final NeatCleanCalendarEvent? event;
  const ReservationDetail({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    DateTime? startTime = event!.startTime;
    DateTime? endTime = event!.endTime;
    String description = event!.description;
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "닫기",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 192, 191, 191)),
                    ),
                  ),
                ],
              ),
              Text(
                "예약 일정",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.date_range, color: Color.fromARGB(255, 159, 208, 213)),
              const SizedBox(width: 10),
              Text(
                "${startTime.year}년 ${startTime.month}월 ${startTime.day}일",
                style: TextStyle(fontSize: 18, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 4),
          Divider(color: Color.fromARGB(255, 192, 191, 191), thickness: 0.3),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time,
                      color: Color.fromARGB(255, 159, 208, 213)),
                  const SizedBox(width: 10),
                  Text(
                    "시작",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 159, 208, 213)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(width: 25),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 25),
              Row(
                children: [
                  Icon(Icons.access_time,
                      color: Color.fromARGB(255, 159, 208, 213)),
                  const SizedBox(width: 10),
                  Text(
                    "종료",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 159, 208, 213)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 4),
          Divider(color: Color.fromARGB(255, 192, 191, 191), thickness: 0.3),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.person, color: Color.fromARGB(255, 159, 208, 213)),
              const SizedBox(width: 10),
              Text(
                description,
                style: TextStyle(fontSize: 18, color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
