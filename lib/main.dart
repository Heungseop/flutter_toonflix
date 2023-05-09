import 'package:flutter/material.dart';
import 'package:flutter_toonflix/screen/home_screen.dart';
import 'package:flutter_toonflix/services/api_service.dart';

void main() {
  ApiService().getTodayToons();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
