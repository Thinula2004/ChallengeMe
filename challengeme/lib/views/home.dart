import 'package:challengeme/components/button.dart';
import 'package:challengeme/components/navigationButton.dart';
import 'package:challengeme/components/topBar.dart';
import 'package:challengeme/services/sessionService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
            TopBar(),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Image.asset(
                'lib/assets/fitness.png',
                width: 250,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF83CFEF),
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Score :',
                        style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${user.score}',
                        style: const TextStyle(
                            color: Color(0xFF1C42BB),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      const Text(
                        'Challenges :',
                        style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${user.challengeCount}',
                        style: TextStyle(
                            color: Color(0xFF1C42BB),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(color: Color(0xFFB6B6B6)),
              width: MediaQuery.of(context).size.width * 0.95,
              height: 2,
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavigationButton(
                    imagePath: 'lib/assets/challenge.png',
                    label: 'Challenges',
                    route: '/challenges'),
                SizedBox(
                  width: 10,
                ),
                NavigationButton(
                    imagePath: 'lib/assets/specialist.png',
                    label: 'Specialists',
                    route: '/specialists'),
                SizedBox(
                  width: 10,
                ),
                NavigationButton(
                    imagePath: 'lib/assets/diet.png',
                    label: 'Diet Plan',
                    route: '/diet')
              ],
            )
          ],
        ),
      );
    });
  }

  void navigate() {
    Navigator.pushNamed(context, '/login');
  }
}
