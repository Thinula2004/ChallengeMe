import 'user.dart';

class Message {
  final String id;
  final String body;
  final User from;
  final User to;
  final String time;

  Message(
      {required this.id,
      required this.body,
      required this.time,
      required this.from,
      required this.to});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      body: json['body'],
      time: json['time'],
      from: User.fromJson(json['from']),
      to: User.fromJson(json['to']),
    );
  }

  @override
  String toString() {
    return 'Message(id: $id body: $body, time: $time, from: ${from.name}, to: ${to.name})';
  }
}
