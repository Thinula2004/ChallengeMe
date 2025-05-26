import 'package:challengeme/components/receivedChallengeCard.dart';
import 'package:challengeme/components/sentChallengeCard.dart';
import 'package:challengeme/components/styles.dart';
import 'package:challengeme/models/challenge.dart';
import 'package:challengeme/services/sessionService.dart';
import 'package:challengeme/services/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:challengeme/components/topBar.dart';
import 'package:challengeme/services/challengeService.dart';

class ChallengeListView extends StatefulWidget {
  const ChallengeListView({super.key});

  @override
  State<ChallengeListView> createState() => _ChallengeListViewState();
}

class _ChallengeListViewState extends State<ChallengeListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _loaded = false;
  List<Challenge> receivedChallenges = [];
  List<Challenge> sentChallenges = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loadAllChallenges();
    }
  }

  Future<void> _loadAllChallenges() async {
    await Future.wait([
      _loadToChallenges(),
      _loadFromChallenges(),
    ]);
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _loaded = true;
    });
  }

  Future<void> _loadToChallenges() async {
    setState(() {
      _loaded = false;
    });
    final user =
        Provider.of<SessionService>(context, listen: false).currentUser;

    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _loaded = true;
    });

    if (user != null) {
      final result = await ChallengeService.getToChallenges(user.id);
      if (result != false) {
        setState(() {
          receivedChallenges = result!;
        });
      } else {
        showWarning(
            context, 'Failed to load challenges. Check your connection');
      }
    } else {
      showWarning(context, 'Failed to load challenges');
    }
  }

  Future<void> _loadFromChallenges() async {
    setState(() {
      _loaded = false;
    });

    final user =
        Provider.of<SessionService>(context, listen: false).currentUser;

    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _loaded = true;
    });

    if (user != null) {
      final result = await ChallengeService.getFromChallenges(user.id);
      if (result != false) {
        setState(() {
          sentChallenges = result!;
        });
      } else {
        showWarning(
            context, 'Failed to load challenges. Check your connection');
      }
    } else {
      showWarning(context, 'Failed to load challenges');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: _loaded
          ? SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(child: Text('- Challenges -', style: title01)),
                        Positioned(
                            right: 0,
                            child: ElevatedButton(
                              onPressed: Create,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                                elevation: MaterialStateProperty.all(0),
                                overlayColor: MaterialStateProperty.all(Colors
                                    .transparent), // removes hover/click effect
                              ),
                              child: Image.asset(
                                'lib/assets/add.png',
                                width: 50,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Received ', style: title02),
                        Expanded(
                            child: Container(
                          height: 2,
                          decoration: BoxDecoration(color: Colors.grey),
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    for (var challenge in receivedChallenges)
                      ReceivedChallengeCard(
                        challenge: challenge,
                        refreshCallback: Refresh,
                      ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Sent ', style: title02),
                        Expanded(
                            child: Container(
                          height: 2,
                          decoration: BoxDecoration(color: Colors.grey),
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    for (var challenge in sentChallenges)
                      SentChallengeCard(
                        challenge: challenge,
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void Refresh() {
    _loadToChallenges();
  }

  void Create() {
    Navigator.pushNamed(context, '/challenge');
  }
}
