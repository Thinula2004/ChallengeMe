import 'package:challengeme/components/styles.dart';
import 'package:challengeme/services/messageService.dart';
import 'package:challengeme/services/util.dart';
import 'package:flutter/material.dart';
import 'package:challengeme/models/message.dart';
import 'package:intl/intl.dart';

class FromMessageCard extends StatelessWidget {
  final Message message;
  final Function refreshCallback;

  const FromMessageCard({
    super.key,
    required this.message,
    required this.refreshCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      message.body,
                      softWrap: true,
                      style: title07(16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => delete(context),
                    child: const Icon(Icons.delete, size: 18),
                  ),
                ],
              ),
              Text(DateFormat.Hm().format(DateTime.parse(message.time))),
            ],
          )),
    );
  }

  void delete(BuildContext context) async {
    bool confirmation =
        await showYesNoDialog(context, 'Do you want to delete this message?');

    if (confirmation) {
      bool response = await MessageService.deleteMessage(message.id);
      if (response) {
        refreshCallback();
      }
    }
  }
}
