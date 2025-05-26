import 'package:challengeme/models/user.dart';
import 'package:challengeme/services/sessionService.dart';
import 'package:challengeme/views/challengeList.dart';
import 'package:challengeme/views/challengeSingle.dart';
import 'package:challengeme/views/chatView.dart';
import 'package:challengeme/views/home.dart';
import 'package:challengeme/views/inquiryList.dart';
import 'package:challengeme/views/login.dart';
import 'package:challengeme/views/signup.dart';
import 'package:challengeme/views/specialistHome.dart';
import 'package:challengeme/views/specialistList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionService = SessionService();
  await sessionService.initSession();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );

  runApp(
    ChangeNotifierProvider.value(
      value: sessionService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final protectedRoutes = {
      '/home',
      '/challenges',
      '/challenge',
      '/specialists',
      '/chat',
      '/specialistHome',
      '/inquiries'
    };

    final user =
        Provider.of<SessionService>(context, listen: false).currentUser;

    return Consumer<SessionService>(
      builder: (context, sessionService, _) {
        return MaterialApp(
          title: 'Challenge ME',
          debugShowCheckedModeBanner: false,
          home: sessionService.isAuthenticated
              ? (user != null && user.role == 'user')
                  ? const HomeView()
                  : const SpecialistHomeView()
              : const LoginView(),
          onGenerateRoute: (settings) {
            final user = sessionService.currentUser;
            final isAuthenticated = user != null;

            if (protectedRoutes.contains(settings.name) && !isAuthenticated) {
              return MaterialPageRoute(builder: (_) => const LoginView());
            }

            if ((settings.name == '/login' || settings.name == '/signup') &&
                isAuthenticated) {
              final user = Provider.of<SessionService>(context, listen: false)
                  .currentUser;

              print('User is $user');

              if (user != null && user.role == 'user') {
                return MaterialPageRoute(builder: (_) => const HomeView());
              } else if (user != null && user.role != 'user') {
                return MaterialPageRoute(
                    builder: (_) => const SpecialistHomeView());
              }
            }

            switch (settings.name) {
              case '/login':
                return MaterialPageRoute(builder: (_) => const LoginView());
              case '/signup':
                return MaterialPageRoute(builder: (_) => const SignupView());
              case '/home':
                return MaterialPageRoute(builder: (_) => const HomeView());
              case '/challenge':
                return MaterialPageRoute(
                    builder: (_) => const ChallengeSingleView());
              case '/challenges':
                return MaterialPageRoute(
                    builder: (_) => const ChallengeListView());
              case '/specialists':
                return MaterialPageRoute(
                    builder: (_) => const SpecialistListView());
              case '/chat':
                final toUser = settings.arguments as User;
                return MaterialPageRoute(builder: (_) => ChatView(to: toUser));
              case '/specialistHome':
                return MaterialPageRoute(
                    builder: (_) => const SpecialistHomeView());
              case '/inquiries':
                return MaterialPageRoute(
                    builder: (_) => const InquiryListView());
              default:
                return MaterialPageRoute(builder: (_) => const LoginView());
            }
          },
        );
      },
    );
  }
}
