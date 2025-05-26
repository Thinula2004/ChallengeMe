import 'package:challengeme/components/styles.dart';
import 'package:challengeme/models/user.dart';
import 'package:flutter/material.dart';

class InquiryCard extends StatefulWidget {
  final User trainee;
  const InquiryCard({super.key, required this.trainee});

  @override
  State<InquiryCard> createState() => _InquiryCardState();
}

class _InquiryCardState extends State<InquiryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(color: Color.fromARGB(255, 230, 230, 230)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.trainee.name}',
                    style: title09(20),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 90,
            child: ElevatedButton(
                onPressed: consult,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 19, 120, 174)),
                ),
                child: Text(
                  'Help',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFffffff),
                      fontWeight: FontWeight.bold),
                )),
          )
        ]));
  }

  void consult() {
    Navigator.pushNamed(context, '/chat', arguments: widget.trainee);
  }
}
