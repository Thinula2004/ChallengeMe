import 'dart:ffi';

import 'package:challengeme/components/styles.dart';
import 'package:challengeme/models/challenge.dart';
import 'package:flutter/material.dart';

class SentChallengeCard extends StatefulWidget {
  final Challenge challenge;

  const SentChallengeCard({super.key, required this.challenge});

  @override
  State<SentChallengeCard> createState() => _SentChallengeCardState();
}

class _SentChallengeCardState extends State<SentChallengeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: Color(0xFF84C4FA),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.challenge.title,
                    style: title03,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(widget.challenge.description),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        'To : ',
                      ),
                      Text(
                        ' ${widget.challenge.to.name}',
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        'Deadline : ',
                      ),
                      Text(
                        ' ${widget.challenge.deadline}',
                        style: title05,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!widget.challenge.completed)
            Container(
                padding: EdgeInsets.only(top: 5),
                width: 115,
                child: Text(
                  'In Progress',
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.right,
                ))
          else
            Container(
                padding: EdgeInsets.only(top: 5),
                width: 115,
                child: Text(
                  'Completed',
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.right,
                ))
        ],
      ),
    );
  }
}
