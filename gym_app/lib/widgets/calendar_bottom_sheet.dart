import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showCalendarBottomSheet(BuildContext context) {
  showMaterialModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 49, 47, 47),
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) => const CalendarBottomSheet(),
  );
}

class CalendarBottomSheet extends StatefulWidget {
  const CalendarBottomSheet({super.key});

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _startTime;
  String? _endTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center, // 🔥 전체 Row의 중앙에 텍스트 배치
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "취소",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Text(
                "2025년 2월 5일",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              labelText: '일정 제목',
              // border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: '시작 시간',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['09:00', '10:00', '11:00', '12:00']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {},
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: '끝 시간',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['13:00', '14:00', '15:00', '16:00']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {},
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(
              labelText: '일정 내용',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // 일정 저장 로직 추가
              Navigator.pop(context);
            },
            child: Text('저장하기'),
          ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _contentController.dispose();
  //   super.dispose();
  // }
}
