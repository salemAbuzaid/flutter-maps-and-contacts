import 'package:flutter/material.dart';
import 'package:progetto_pilota/screens/map-screen.dart';
import 'package:progetto_pilota/screens/intro_screen.dart';

void main() {
  runApp(const NavigationApp());
}

class NavigationApp extends StatelessWidget {
  const NavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      routes: {
        '/' : (context) => IntroScreen(),
        '/map' :(context) => MapScreen(),
      },
      initialRoute: '/',
    );
  }
}
