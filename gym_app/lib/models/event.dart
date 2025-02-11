class Event {
  final String color;
  final String start;
  final String description;
  final String end;
  final int id;
  final String title;
  final String type;

  Event({
    required this.color,
    required this.start,
    required this.description,
    required this.end,
    required this.id,
    required this.title,
    required this.type,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      color: json['color'],
      start: json['start'],
      description: json['description'],
      end: json['end'],
      id: json['id'],
      title: json['title'],
      type: json['type'],
    );
  }
}
