import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gym_app/widgets/calendar_bottom_sheet.dart';

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
              showCalendarBottomSheet(context);
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
