import 'package:flutter/material.dart';
import 'package:saathi/screens/get_started_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.grey[400]),
        ),
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      title: 'Matrimonial App',
      home: GetStartedScreen(),
    );
  }
}