class Comment {
  final int no;
  final String commentDate;
  final int trainerNo;
  final int userNo;
  final String? ccontent;
  final String? fcontent;

  Comment({
    required this.no,
    required this.commentDate,
    required this.trainerNo,
    required this.userNo,
    this.ccontent,
    this.fcontent,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      no: json['no'],
      commentDate: json['commentDate'],
      trainerNo: json['trainerNo'],
      userNo: json['userNo'],
      ccontent: json['cContent'],
      fcontent: json['fContent'],
    );
  }
}
