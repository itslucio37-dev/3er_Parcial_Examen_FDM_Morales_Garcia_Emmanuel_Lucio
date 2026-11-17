import 'package:fit_track_pro/features/auth/screens/auth_chech_screen.dart';
import 'package:flutter/material.dart';
import 'package:fit_track_pro/features/auth/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrackPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const AuthCheckScreen(),
    );
  }
}
