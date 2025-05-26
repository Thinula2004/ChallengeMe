import 'user.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final User from;
  final User to;
  final String deadline;
  final bool completed;

  Challenge(
      {required this.id,
      required this.title,
      required this.description,
      required this.from,
      required this.to,
      required this.deadline,
      required this.completed});

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        from: User.fromJson(json['from']),
        to: User.fromJson(json['to']),
        deadline: json['deadline'],
        completed: json['completed']);
  }

  int get daysRemaining {
    final deadlineDate = DateTime.parse(deadline);
    final now = DateTime.now();
    final difference =
        deadlineDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    return difference + 1;
  }

  @override
  String toString() {
    return 'Challenge(id: $id title: $title, description: $description, from: ${from.name}, to: ${to.name}, deadline: $deadline, completed: $completed)';
  }
}
