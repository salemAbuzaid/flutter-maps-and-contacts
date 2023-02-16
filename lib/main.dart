import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progetto_pilota/screens/contact_screen.dart';
import 'package:progetto_pilota/screens/login.dart';
import 'package:progetto_pilota/screens/map-screen.dart';
import 'package:progetto_pilota/screens/intro_screen.dart';

import 'firebase_options.dart';

void main() async {
  // the following line is important for making the main method asynchronouse, otherwise it explodes with an Exeption
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NavigationApp());
}

class NavigationApp extends StatelessWidget {
  const NavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      routes: {
        '/': (context) {
          if (FirebaseAuth.instance.currentUser == null) {
            return Login();
          } else {
            return IntroScreen();
          }
        },
        '/home': (context) => IntroScreen(),
        '/map': (context) => MapScreen(),
        '/contacts': (context) => ContactScreen(),
      },
      initialRoute: '/',
    );
  }
}
