import 'package:challengeme/components/button.dart';
import 'package:challengeme/components/styles.dart';
import 'package:challengeme/components/topBar.dart';
import 'package:challengeme/models/challenge.dart';
import 'package:challengeme/models/user.dart';
import 'package:challengeme/services/auth_service.dart';
import 'package:challengeme/services/challengeService.dart';
import 'package:challengeme/services/sessionService.dart';
import 'package:challengeme/services/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChallengeSingleView extends StatefulWidget {
  const ChallengeSingleView({super.key});

  @override
  State<ChallengeSingleView> createState() => _ChallengeSingleViewState();
}

class _ChallengeSingleViewState extends State<ChallengeSingleView>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late AnimationController _controller;
  DateTime? _selectedDate;
  User? _selectedUser;
  bool _loaded = false;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loadUsers();
    }
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loaded = false;
    });

    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _loaded = true;
    });

    try {
      final result = await AuthService().loadUsers();

      setState(() {
        users = result;
      });

      final user =
          Provider.of<SessionService>(context, listen: false).currentUser;

      if (user != null) {
        users = users.where((u) => u.id != user.id).toList();
      }
    } catch (e) {
      print('Error: $e');
      showWarning(context, 'Failed to fetch users. Try reloading the page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: _loaded
          ? SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 30, left: 20, bottom: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '- Create Challenge -',
                      style: title01,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: const Color(
                            0xFFF1F4FF), // background color of dropdown list
                        shadowColor: Colors.black.withOpacity(0.2),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                      child: DropdownButtonFormField<User>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: 'Select User (To)',
                          filled: true,
                          fillColor: const Color(0xFFF1F4FF),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 17, vertical: 8),
                          hintStyle: const TextStyle(
                            fontFamily: "Poppins_light",
                            fontSize: 17,
                            color: Color(0xFF626262),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                width: 1.6, color: Color(0x55AFBBE7)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                width: 1.6, color: Color(0xFF1F41BB)),
                          ),
                        ),
                        value: _selectedUser,
                        onChanged: (User? value) {
                          setState(() {
                            _selectedUser = value;
                          });
                        },
                        style: const TextStyle(
                            fontFamily: "Poppins_bold",
                            fontSize: 18,
                            color: Color.fromARGB(255, 17, 47, 156),
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500),
                        items: users.map((User user) {
                          return DropdownMenuItem<User>(
                            value: user,
                            child: Text('${user.name} (${user.score})'),
                          );
                        }).toList(),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: input01('Enter Challenge Title'),
                    style: const TextStyle(
                        fontFamily: "Poppins_bold",
                        fontSize: 18,
                        color: Color.fromARGB(255, 17, 47, 156),
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500),
                    cursorColor: const Color(0xFF1F41BB),
                  ),
                  const SizedBox(height: 20),
                  // const Text("Description"),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: input01("Enter Challenge Description"),
                    style: const TextStyle(
                        fontFamily: "Poppins_bold",
                        fontSize: 18,
                        color: Color.fromARGB(255, 17, 47, 156),
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500),
                    cursorColor: const Color(0xFF1F41BB),
                  ),
                  const SizedBox(height: 20),
                  // const Text("Deadline"),
                  InkWell(
                    onTap: _pickDate,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        InputDecorator(
                          decoration: input01('Select Deadline'),
                          child: Text(
                            _selectedDate != null
                                ? _selectedDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]
                                : 'Select deadline',
                            style: TextStyle(
                              fontFamily: "Poppins_bold",
                              fontSize: _selectedDate != null ? 18 : 17,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w500,
                              color: _selectedDate != null
                                  ? const Color(0xFF1F41BB)
                                  : const Color(0xFF5D5D5E),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Color(0xFF5D5D5E),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Center(
                      child: Button(
                    callback: Submit,
                    text: "Create",
                    height: 50,
                    width: 150,
                  )),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void Submit() async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    final user =
        Provider.of<SessionService>(context, listen: false).currentUser;

    if (title.trim() == '') {
      showWarning(context, 'Title is empty');
      return;
    } else if (description.trim() == '') {
      showWarning(context, 'Description is empty');
      return;
    } else if (_selectedUser == null) {
      showWarning(context, 'Please select a user');
      return;
    } else if (_selectedDate == null) {
      showWarning(context, 'Please select a date');
      return;
    } else if (user == null) {
      showWarning(context, 'Session Expired');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    String to = _selectedUser!.id;
    String from = user.id;
    String deadline = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    Challenge? response = await ChallengeService()
        .createChallenge(title, description, from, to, deadline);

    print(response);

    if (response == null) {
      showWarning(context, 'Failed to create the challenge');
      return;
    }
    showSuccess(context, 'Challenge Created Successfully');
    Navigator.pushReplacementNamed(context, '/challenges');
  }
}
