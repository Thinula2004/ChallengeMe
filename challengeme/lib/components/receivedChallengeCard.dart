import 'dart:ffi';

import 'package:challengeme/components/styles.dart';
import 'package:challengeme/models/challenge.dart';
import 'package:challengeme/models/user.dart';
import 'package:challengeme/services/challengeService.dart';
import 'package:challengeme/services/sessionService.dart';
import 'package:challengeme/services/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivedChallengeCard extends StatefulWidget {
  final Challenge challenge;
  final Function refreshCallback;

  const ReceivedChallengeCard(
      {super.key, required this.challenge, required this.refreshCallback});

  @override
  State<ReceivedChallengeCard> createState() => _ReceivedChallengeCardState();
}

class _ReceivedChallengeCardState extends State<ReceivedChallengeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: widget.challenge.completed
              ? Color(0xFF9BDDCA)
              : Color(0xFFFBDF86),
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
                        'From : ',
                      ),
                      Text(
                        ' ${widget.challenge.from.name}',
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
                  if (!widget.challenge.completed)
                    if (widget.challenge.daysRemaining > 0)
                      Text(
                        '${widget.challenge.daysRemaining} Days Remaining',
                        style: title04,
                      )
                    else
                      Text(
                        '${(widget.challenge.daysRemaining) * -1} Days Due',
                        style: title04,
                      )
                ],
              ),
            ),
          ),
          if (!widget.challenge.completed)
            SizedBox(
              width: 115,
              child: ElevatedButton(
                  onPressed: onComplete,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF13AE82)),
                  ),
                  child: Text(
                    'Complete',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFFBDF86),
                        fontWeight: FontWeight.bold),
                  )),
            )
          else
            Container(
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              width: 115,
              child: Image.asset(
                'lib/assets/tick.png',
                height: 40,
                fit: BoxFit.contain,
              ),
            )
        ],
      ),
    );
  }

  void onComplete() async {
    String challengeId = widget.challenge.id;

    bool confirmation = await showYesNoDialog(
        context, 'Do you want to complete this challenge?');

    if (!confirmation) {
      return;
    }

    User? res = await ChallengeService().completeChallenge(challengeId);

    if (res == null) {
      showWarning(context, 'Failed to complete challenge');
      return;
    }

    showSuccess(context, 'Successfully completed the challenge');

    Provider.of<SessionService>(context, listen: false).saveUser(res);

    widget.refreshCallback();
  }
}
