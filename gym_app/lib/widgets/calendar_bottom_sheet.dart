import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:omni_datetime_picker/omni_datetime_picker.dart';

void showCalendarBottomSheet(BuildContext context, DateTime selectedDate) {
  showMaterialModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 49, 47, 47),
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
    ),
    builder: (context) =>
        CalendarBottomSheet(selectedDate: selectedDate), // selectedDate 전달
  );
}

class CalendarBottomSheet extends StatefulWidget {
  final DateTime selectedDate; // selectedDate를 받아옴

  const CalendarBottomSheet(
      {super.key, required this.selectedDate}); // 생성자에서 selectedDate 받기

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  DateTime? startTime;
  DateTime? endTime;

  void pickStartTime() async {
    DateTime? selectedStartTime = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoDatePicker(
          initialDateTime: startTime ?? DateTime.now(),
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (DateTime newDateTime) {},
        );
      },
    );

    if (selectedStartTime != null) {
      setState(() {
        startTime = selectedStartTime;
      });
    }
  }

  void pickEndTime() async {
    DateTime? selectedEndTime = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoDatePicker(
          initialDateTime: endTime ?? DateTime.now(),
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (DateTime newDateTime) {},
        );
      },
    );

    if (selectedEndTime != null) {
      setState(() {
        endTime = selectedEndTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                      "취소",
                      style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 192, 191, 191)),
                    ),
                  ),
                ],
              ),
              Text(
                "${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일",
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
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: pickStartTime,
                  child: Text(
                    startTime != null
                        ? "${startTime!.hour}:${startTime!.minute.toString().padLeft(2, '0')}"
                        : '시작 시간 선택',
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: pickEndTime,
                  child: Text(
                    endTime != null
                        ? "${endTime!.hour}:${endTime!.minute.toString().padLeft(2, '0')}"
                        : '끝 시간 선택',
                  ),
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
}
