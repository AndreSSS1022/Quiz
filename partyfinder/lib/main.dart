import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Party Finder',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1B263B),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF185ADB),
          secondary: const Color(0xFF0A2342),
        ),
        cardColor: const Color(0xFF222B45),
      ),
      home: const Login(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const MyHomePage(title: 'PartyFinder'),
        '/register': (context) => const Register(),
      },
    );
  }
}