import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:partyfinder/screens/mapa.dart';
import 'package:partyfinder/screens/bookings.dart';
import 'package:partyfinder/screens/categories.dart';
import 'package:partyfinder/screens/login.dart';
import 'package:partyfinder/screens/home.dart';
import 'package:partyfinder/screens/register.dart';
import 'package:partyfinder/screens/storeprofile.dart';
import 'package:partyfinder/utils/session_manager.dart'; // ✅ Importamos el SessionManager

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const MyHomePage(title: 'PartyFinder'),
        '/register': (context) => const Register(),
        '/mapa': (context) => const Mapa(),
        '/bookings': (context) => const Bookings(),
        '/categories': (context) => const Categories(),
        '/storeprofile': (context) => const StoreProfile(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Espera un poco para mostrar el splash
    await Future.delayed(const Duration(seconds: 1));

    final isLogged = await SessionManager.isLoggedIn();

    if (!mounted) return;

    if (isLogged) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF185ADB)),
            SizedBox(height: 16),
            Text(
              'Cargando...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
