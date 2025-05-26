import 'package:challengeme/components/styles.dart';
import 'package:flutter/material.dart';
import 'package:challengeme/models/message.dart';
import 'package:intl/intl.dart';

class ToMessageCard extends StatelessWidget {
  final Message message;

  const ToMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.body,
              softWrap: true,
              style: title07(16),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              DateFormat.Hm().format(
                DateTime.parse(message.time).toLocal(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
