import 'package:challengeme/components/inquiryCard.dart';
import 'package:challengeme/components/specialistCard.dart';
import 'package:challengeme/components/specialistTopbar.dart';
import 'package:challengeme/components/styles.dart';
import 'package:challengeme/components/topBar.dart';
import 'package:challengeme/models/user.dart';
import 'package:challengeme/services/auth_service.dart';
import 'package:challengeme/services/sessionService.dart';
import 'package:challengeme/services/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InquiryListView extends StatefulWidget {
  const InquiryListView({super.key});
  @override
  State<InquiryListView> createState() => _InquiryListViewState();
}

class _InquiryListViewState extends State<InquiryListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<User> trainees = [];
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
      _loadTrainees();
    }
  }

  Future<void> _loadTrainees() async {
    setState(() {
      _loaded = false;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _loaded = true;
    });
    final user =
        Provider.of<SessionService>(context, listen: false).currentUser;

    if (user == null) {
      showWarning(context, 'Session Expired. Please Login Again');
      return;
    }
    final result = await AuthService().loadTrainees(user.id);

    setState(() {
      trainees = result;
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
      appBar: SpecialistTopBar(),
      body: _loaded
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
              child: Container(
                child: Column(children: [
                  Center(
                    child: Text(
                      '- Inquiries -',
                      style: title01,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 140, 140, 140),
                    ),
                    height: 2,
                  ),
                  for (User trainee in trainees)
                    Column(
                      children: [
                        InquiryCard(trainee: trainee),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 140, 140, 140),
                          ),
                          height: 2,
                        )
                      ],
                    )
                ]),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
