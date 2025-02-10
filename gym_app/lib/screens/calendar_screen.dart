import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<NeatCleanCalendarEvent> _eventList = [
    NeatCleanCalendarEvent('MultiDay Event A',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 10, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 2, 12, 0),
        color: Colors.orange,
        isMultiDay: true),
    NeatCleanCalendarEvent('Allday Event B',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day - 2, 14, 30),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 2, 17, 0),
        color: Colors.pink,
        isAllDay: true),
    NeatCleanCalendarEvent('Normal Event D',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 14, 30),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 17, 0),
        color: Colors.indigo),
  ];

  void _handleNewDate(date) {
    print('Date selected: $date');
  }

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  Widget eventCell(BuildContext context, NeatCleanCalendarEvent event,
      String start, String end) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Text('Calendar Event: ${event.summary} from $start to $end'));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 49, 47, 47),
          colorScheme: ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Colors.white,
            surface: Colors.grey,
            onSurface: Color.fromARGB(255, 159, 208, 213),
          ),
        ),
        child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Color.fromARGB(255, 49, 47, 47),
          //   title: Text(
          //     "일정",
          //     style: TextStyle(color: Colors.white), // 텍스트 색깔 설정
          //   ),
          // ),
          body: SafeArea(
            child: Calendar(
              // bottomBarColor: Color.fromARGB(255, 49, 47, 47),
              defaultDayColor: Colors.white,
              startOnMonday: true,
              weekDays: ['월', '화', '수', '목', '금', '토', '일'],
              eventsList: _eventList,
              isExpandable: true,
              eventDoneColor: Colors.green,
              selectedColor: Colors.pink,
              selectedTodayColor: Colors.red,
              todayColor: Colors.blue,
              eventColor: null,
              locale: 'ko_KR',
              todayButtonText: '오늘',
              allDayEventText: '종일',
              multiDayEndText: '종료',
              isExpanded: true,
              expandableDateFormat: 'yyyy/MM/dd (E)',
              datePickerType: DatePickerType.date,
              dayOfWeekStyle: TextStyle(
                  color: Color.fromARGB(255, 159, 208, 213),
                  fontWeight: FontWeight.w800,
                  fontSize: 14),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                backgroundColor: Color.fromARGB(255, 49, 47, 47),
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (context) => Container(
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
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
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
                              items: <String>[
                                '09:00',
                                '10:00',
                                '11:00',
                                '12:00'
                              ].map((String value) {
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
                              items: <String>[
                                '13:00',
                                '14:00',
                                '15:00',
                                '16:00'
                              ].map((String value) {
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
                ),
              );
            },
            child: const Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 159, 208, 213),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: "Community"),
            ],
          ),
        ));
  }
}
