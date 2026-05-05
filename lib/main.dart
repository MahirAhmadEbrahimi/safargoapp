import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "screens/login_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 LOCK PORTRAIT (like your previous setup)
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 THEME (optional but cleaner UI)
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      // 🔥 START FROM LOGIN
      home: const LoginScreen(),
    );
  }
}
