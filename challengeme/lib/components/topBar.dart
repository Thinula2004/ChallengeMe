import 'package:challengeme/services/sessionService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  TopBar({Key? key})
      : preferredSize = const Size.fromHeight(100),
        super(key: key);

  void _logout(BuildContext context) {
    Provider.of<SessionService>(context, listen: false).clearUser();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 25, right: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 0),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const Text(
            'Challenge ME',
            style: TextStyle(
              color: Color(0xFF1F41BB),
              fontSize: 40,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          ),
          Positioned(
            right: 0,
            child: PopupMenuButton<String>(
              icon: const Icon(
                Icons.menu,
                color: Color(0xFF1F41BB),
                size: 40,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'home':
                    Navigator.pushNamed(context, '/home');
                    break;
                  case 'challenges':
                    Navigator.pushNamed(context, '/challenges');
                  case 'specialists':
                    Navigator.pushNamed(context, '/specialists');
                    break;
                  case 'diet':
                    Navigator.pushNamed(context, '/diet');
                    break;
                  case 'logout':
                    _logout(context);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'home',
                  child: Text('Home'),
                ),
                const PopupMenuItem<String>(
                  value: 'challenges',
                  child: Text('Challenges'),
                ),
                const PopupMenuItem<String>(
                  value: 'specialists',
                  child: Text('Specialists'),
                ),
                const PopupMenuItem<String>(
                  value: 'diet',
                  child: Text('Diet Plan'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(color: Color(0xFF1F41BB)),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.logout,
                        color: Color(0xFF1F41BB),
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
