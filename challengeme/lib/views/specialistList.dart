import 'package:challengeme/components/specialistCard.dart';
import 'package:challengeme/components/styles.dart';
import 'package:challengeme/components/topBar.dart';
import 'package:challengeme/models/user.dart';
import 'package:challengeme/services/auth_service.dart';
import 'package:flutter/material.dart';

class SpecialistListView extends StatefulWidget {
  const SpecialistListView({super.key});
  @override
  State<SpecialistListView> createState() => _SpecialistListViewState();
}

class _SpecialistListViewState extends State<SpecialistListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<User> specialists = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loadSpecialists();
    }
  }

  Future<void> _loadSpecialists() async {
    setState(() {
      _loaded = false;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _loaded = true;
    });

    final result = await AuthService().loadSpecialists();

    setState(() {
      specialists = result;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: _loaded
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Container(
                child: Column(children: [
                  Center(
                    child: Text(
                      '- Specialists -',
                      style: title01,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  for (User specialist in specialists)
                    SpecialistCard(specialist: specialist)
                ]),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
