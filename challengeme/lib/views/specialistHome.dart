import 'package:challengeme/components/button.dart';
import 'package:challengeme/components/navigationButton.dart';
import 'package:challengeme/components/specialistTopbar.dart';
import 'package:challengeme/components/topBar.dart';
import 'package:challengeme/services/sessionService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpecialistHomeView extends StatefulWidget {
  const SpecialistHomeView({super.key});

  @override
  State<SpecialistHomeView> createState() => _SpecialistHomeViewState();
}

class _SpecialistHomeViewState extends State<SpecialistHomeView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SessionService>(builder: (context, session, child) {
      final user = session.currentUser;

      // Safety check
      if (user == null) {
        return const Text("No user logged in");
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SpecialistTopBar(),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Image.asset(
                'lib/assets/fitness.png',
                width: 200,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  '${user.name}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${user.capitalizedRole()}',
                  style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(color: Color(0xFFB6B6B6)),
              width: MediaQuery.of(context).size.width * 0.95,
              height: 2,
            ),
            const SizedBox(height: 25),
            const NavigationButton(
              imagePath: 'lib/assets/trainee.png',
              label: 'Trainee Inquiries',
              route: '/inquiries',
              width: 230,
              height: 180,
            ),
          ],
        ),
      );
    });
  }
}
