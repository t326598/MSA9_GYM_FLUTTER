import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:gym_app/models/calendar_response.dart';
import 'package:gym_app/service/calendar_service.dart';
import 'package:gym_app/widgets/bottom_sheet.dart';
import 'package:gym_app/widgets/event_cell_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gym_app/widgets/calendar_bottom_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _currentIndex = 3;
  final List<String> routes = [
    '/home',
    '/ticket',
    '/reservationInsert',
    '/calendar',
    '/myPage'
  ];
  CalendarResponse? calendarResponse;
  CalendarService calendarService = CalendarService();

  DateTime? _selectedDate = DateTime.now().toLocal(); // 선택된 날짜 저장

  final List<NeatCleanCalendarEvent> _eventList = [];

  void _handleNewDate(date) {
    print('Date selected: $date');
  }

  void _onDateSelected(DateTime selectedDate) {
    // 날짜 선택 시 해당 날짜로 상태 업데이트
    setState(() {
      _selectedDate = selectedDate;
    });

    // 선택된 날짜 출력
    print("선택된 날짜: ${selectedDate.toLocal()}");
  }

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));

    _fetchCalendarEvents();
  }

  Widget eventCell(BuildContext context, NeatCleanCalendarEvent event,
      String start, String end) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Text('Calendar Event: ${event.summary} from $start to $end'));
  }

  void _fetchCalendarEvents() async {
    final response = await calendarService.getPlans();

    if (response != null) {
      setState(() {
        _eventList.addAll(response.toNeatCleanCalendarEvents());
      });
    }
  }

  void _fetchCalendarEventsByDate(DateTime selectedDate) async {
    final response = await calendarService.getPlansByDate(selectedDate);
    print(response);
    if (response != null) {
      _eventList.clear();
      setState(() {
        _eventList.addAll(response.toNeatCleanCalendarEvents());
      });
    }
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
              eventTileHeight: 80.0,
              eventCellBuilder: (context, event, start, end) {
                return EventCellWidget(
                  event: event,
                  start: start,
                  end: end,
                );
              },
              onMonthChanged: (date) {
                print("달이 바뀌었습니다");
                _fetchCalendarEventsByDate(date);
              },
              onDateSelected: _onDateSelected,
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
              showCalendarBottomSheet(context, _selectedDate!);
            },
            child: const Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 159, 208, 213),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });

              if (index >= 0 && index < routes.length) {
                Navigator.pushNamed(context, routes[index]);
              }
            },
          ),
        ));
  }
}
