import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:gym_app/models/comment.dart';
import 'package:gym_app/models/event.dart';
import 'package:hexcolor/hexcolor.dart';

class CalendarResponse {
  final Comment comment;
  final String userAuthAuth;
  final List<Event> planEvents;
  final List<Event> reservationEvents;

  CalendarResponse({
    required this.comment,
    required this.userAuthAuth,
    required this.planEvents,
    required this.reservationEvents,
  });

  factory CalendarResponse.fromJson(Map<String, dynamic> json) {
    return CalendarResponse(
      comment: Comment.fromJson(json['comment']),
      userAuthAuth: json['userAuthAuth'],
      planEvents: (json['planEvents'] as List<dynamic>)
          .map((e) => Event.fromJson(e))
          .toList(),
      reservationEvents: (json['reservationEvents'] as List<dynamic>)
          .map((e) => Event.fromJson(e))
          .toList(),
    );
  }

  List<NeatCleanCalendarEvent> toNeatCleanCalendarEvents() {
    List<NeatCleanCalendarEvent> events = [];
    // print(DateTime.parse(planEvents.first.start).toLocal().toString());

    for (var event in [...planEvents, ...reservationEvents]) {
      events.add(NeatCleanCalendarEvent(
        event.title,
        startTime: DateTime.parse(event.start).toLocal(),
        endTime: DateTime.parse(event.end).toLocal(),
        // description: event.description,
        color: HexColor(event.color),
        id: event.id.toString(),
        metadata: {'type': event.type},
      ));
    }

    return events;
  }
}
