import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';

class ReservationInsertScreen extends StatefulWidget {
  const ReservationInsertScreen({super.key});

  @override
  State<ReservationInsertScreen> createState() => _ReservationInsertScreenState();
}

class _ReservationInsertScreenState extends State<ReservationInsertScreen> {
  final now = DateTime.now();

  Future<List<DateTimeRange>> getBookings({required DateTime start, required DateTime end}) async {
    return [
      DateTimeRange(
        start: now.add(const Duration(days: 1, hours: 10)),
        end: now.add(const Duration(days: 1, hours: 10, minutes: 30)),
      ),
      DateTimeRange(
        start: now.add(const Duration(days: 2, hours: 12)),
        end: now.add(const Duration(days: 2, hours: 12, minutes: 30)),
      ),
    ];
  }

  Stream<dynamic> getBookingStream({required DateTime start, required DateTime end}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBooking({required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    return newBooking;
  }

  List<DateTimeRange> convertStreamResultToDateTimeRanges({required dynamic streamResult}) {
    return [
      DateTimeRange(
        start: now.add(const Duration(days: 1, hours: 10)),
        end: now.add(const Duration(days: 1, hours: 10, minutes: 30)),
      ),
      DateTimeRange(
        start: now.add(const Duration(days: 2, hours: 12)),
        end: now.add(const Duration(days: 2, hours: 12, minutes: 30)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PT 예약')),
      body: Column(
        children: [
          // 트레이너 정보 섹션
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 50, 
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '트레이너 이름',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '트레이너 간단 소개',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 캘린더 섹션
          Expanded(
            child: BookingCalendar(
              bookingService: BookingService(
                serviceName: 'Meeting Room',
                serviceDuration: 60,
                bookingStart: DateTime(now.year, now.month, now.day, 10, 0),
                bookingEnd: DateTime(now.year, now.month, now.day, 22, 0),
              ),
              getBookingStream: getBookingStream,
              uploadBooking: uploadBooking,
              convertStreamResultToDateTimeRanges: convertStreamResultToDateTimeRanges,
              availableSlotText: '예약 가능 시간',
              selectedSlotText: '선택한 시간',
              bookedSlotText: '예약 마감',
              bookingGridChildAspectRatio: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}