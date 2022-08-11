import 'dart:convert';

List<Day> dayFromJson(String str) =>
    List<Day>.from(json.decode(str).map((x) => Day.fromJson(x)));

String dayToJson(List<Day> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Day {
  Day({
    required this.startTime,
    required this.endTime,
    required this.date,
  });

  String startTime;
  String endTime;
  String date;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        startTime: json["startTime"],
        endTime: json["endTime"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
        "date": date,
      };
}
