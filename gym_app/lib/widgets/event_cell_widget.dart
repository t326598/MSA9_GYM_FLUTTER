import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gym_app/service/calendar_service.dart';
import 'package:gym_app/widgets/calendar_bottom_sheet.dart';
import 'package:gym_app/widgets/reservation_detail.dart';

class EventCellWidget extends StatefulWidget {
  final dynamic event; // 이벤트 객체
  final String start; // 시작 시간
  final String end; // 종료 시간
  final VoidCallback? onEventUpdated;

  const EventCellWidget({
    Key? key,
    required this.event,
    required this.start,
    required this.end,
    this.onEventUpdated,
  }) : super(key: key);

  @override
  _EventCellWidgetState createState() => _EventCellWidgetState();

  Column singleDayTimeWidget(String start, String end) {
    // widget.onPrintLog != null
    //     ? widget.onPrintLog!('SingleDayEvent')
    //     : print('SingleDayEvent');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(start,
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 159, 208, 213))),
        Text(end,
            style: TextStyle(
                fontSize: 15, color: Color.fromARGB(255, 126, 162, 165))),
      ],
    );
  }
}

class _EventCellWidgetState extends State<EventCellWidget> {
  final CalendarService calendarService = CalendarService();

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(), // 슬라이드 애니메이션 효과
          children: [
            SlidableAction(
              onPressed: (context) async {
                bool success = await calendarService
                    .deletePlan(int.parse(widget.event.id));
                if (success) {
                  widget.onEventUpdated?.call();
                }
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '삭제',
              flex: 2,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: Color.fromARGB(255, 78, 78, 78),
            // borderRadius: BorderRadius.circular(10), // 기존 스타일 유지
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 78, 78, 78), // 테두리 색상
                width: 1.2, // 테두리 두께
              ),
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (widget.event.metadata['type'] == 'plan') {
                showCalendarBottomSheet(
                  context,
                  widget.event.startTime,
                  event: widget.event,
                  onEventUpdated: () {
                    if (widget.onEventUpdated != null) {
                      widget.onEventUpdated!(); // 콜백 실행
                    }
                  },
                );
              } else {
                showReservationDetail(context, widget.event);
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // 왼쪽: 이벤트 아이콘 또는 색상 표시
                Expanded(
                  flex: widget.event.wide != null && widget.event.wide! == true
                      ? 25
                      : 5,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        // 아이콘이 없으면 색상을 사용
                        color: widget.event.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0), // 아이콘과 텍스트 사이의 간격
                // 중간: 이벤트 제목만 표시
                Expanded(
                  flex: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.event.summary, // 제목만 표시
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.0), // 텍스트와 시간 사이의 간격
                // 오른쪽: 이벤트 시간 표시
                Expanded(
                  flex: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.singleDayTimeWidget(
                        widget.start, widget.end), // Single day event
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
