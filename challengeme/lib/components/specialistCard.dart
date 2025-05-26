import 'package:challengeme/components/styles.dart';
import 'package:challengeme/models/user.dart';
import 'package:flutter/material.dart';

class SpecialistCard extends StatefulWidget {
  final User specialist;
  const SpecialistCard({super.key, required this.specialist});

  @override
  State<SpecialistCard> createState() => _SpecialistCardState();
}

class _SpecialistCardState extends State<SpecialistCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 188, 225, 255),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.specialist.name}',
                    style: title02,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${widget.specialist.capitalizedRole()}',
                    style: title06,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 105,
            child: ElevatedButton(
                onPressed: consult,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 19, 120, 174)),
                ),
                child: Text(
                  'Consult',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFffffff),
                      fontWeight: FontWeight.bold),
                )),
          )
        ]));
  }

  void consult() {
    Navigator.pushNamed(context, '/chat', arguments: widget.specialist);
  }
}
