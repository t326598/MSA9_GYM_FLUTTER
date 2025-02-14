import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:gym_app/models/calendar_response.dart';
import 'package:gym_app/models/comment.dart';
import 'package:gym_app/service/calendar_service.dart';
import 'package:gym_app/widgets/bottom_sheet.dart';
import 'package:gym_app/widgets/event_cell_widget.dart';
import 'package:gym_app/widgets/calendar_bottom_sheet.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CalendarScreen extends StatefulWidget {
  // final ValueNotifier<ThemeMode> theme = ValueNotifier(ThemeMode.dark);
  // const CalendarScreen({Key? key, required this.theme}) : super(key: key);
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

  // floatingbuttonAction 관련 변수
  var theme = ValueNotifier(ThemeMode.dark);
  var rmicons = false;

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
                  onEventUpdated: () {
                    _fetchCalendarEventsByDate(_selectedDate!);
                  },
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
          floatingActionButton: SpeedDial(
            // animatedIcon: AnimatedIcons.menu_close,
            // animatedIconTheme: IconThemeData(size: 22.0),
            // / This is ignored if animatedIcon is non null
            // child: Text("open"),
            // activeChild: Text("close"),
            icon: Icons.menu,
            activeIcon: Icons.close,
            spacing: 3,
            openCloseDial: ValueNotifier<bool>(false),
            childPadding: const EdgeInsets.all(5),
            spaceBetweenChildren: 4,
            backgroundColor: Color.fromARGB(255, 159, 208, 213),

            /// Transition Builder between label and activeLabel, defaults to FadeTransition.
            labelTransitionBuilder: (widget, animation) =>
                ScaleTransition(scale: animation, child: widget),

            /// The below button size defaults to 56 itself, its the SpeedDial childrens size
            direction: SpeedDialDirection.up,

            /// If true user is forced to close dial manually

            /// If false, backgroundOverlay will not be rendered.
            renderOverlay: true,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => debugPrint('OPENING DIAL'),
            onClose: () => debugPrint('DIAL CLOSED'),
            useRotationAnimation: true,
            tooltip: 'Open Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            // foregroundColor: Colors.black,
            // backgroundColor: Colors.white,
            // activeForegroundColor: Colors.red,
            // activeBackgroundColor: Colors.blue,
            elevation: 8.0,
            animationCurve: Curves.elasticInOut,
            isOpenOnStart: false,
            // shape: const StadiumBorder(),
            // shape: const RoundedRectangleBorder(),
            // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.add),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: '일정 추가',
                onTap: () {
                  showCalendarBottomSheet(
                    context,
                    _selectedDate!,
                    onEventUpdated: () {
                      _fetchCalendarEventsByDate(_selectedDate!);
                    },
                  );
                },
                onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
              ),
              SpeedDialChild(
                child: const Icon(Icons.comment),
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                label: '트레이너 코멘트',
                onTap: () async {
                  Comment? comment =
                      await calendarService.getCommentByDate(_selectedDate!);
                  showMaterialModalBottomSheet(
                    backgroundColor: const Color.fromARGB(255, 49, 47, 47),
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(18.0)),
                    ),
                    builder: (context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.5,
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
                                            color: Color.fromARGB(
                                                255, 192, 191, 191)),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "트레이너 코멘트",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // ✅ 스크롤 가능한 부분 추가
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.date_range,
                                            color: Colors.white),
                                        const SizedBox(width: 10),
                                        Text(
                                          "${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Divider(
                                        color:
                                            Color.fromARGB(255, 192, 191, 191),
                                        thickness: 0.3),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.short_text,
                                            color: Colors.white),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          // ✅ 긴 텍스트도 줄바꿈됨
                                          child: Text(
                                            comment?.ccontent ?? "",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Divider(
                                        color:
                                            Color.fromARGB(255, 192, 191, 191),
                                        thickness: 0.3),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.restaurant,
                                            color: Colors.white),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          // ✅ 긴 텍스트도 줄바꿈됨
                                          child: Text(
                                            comment?.fcontent ?? "",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              // SpeedDialChild(
              //   child: !rmicons ? const Icon(Icons.margin) : null,
              //   backgroundColor: Colors.indigo,
              //   foregroundColor: Colors.white,
              //   label: 'Show Snackbar',
              //   visible: true,
              //   onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text(("Third Child Pressed")))),
              //   onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
              // ),
            ],
          ),
          // FloatingActionButton(
          //   onPressed: () {
          //     showCalendarBottomSheet(
          //       context,
          //       _selectedDate!,
          //       onEventUpdated: () {
          //         _fetchCalendarEventsByDate(
          //             _selectedDate!); // ✅ 선택된 날짜의 이벤트 다시 불러오기
          //       },
          //     );
          //   },
          //   backgroundColor: Color.fromARGB(255, 159, 208, 213),
          //   child: const Icon(Icons.add),
          // ),
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
