import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Budget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Color(0xff1A535C),
        fontFamily: 'Josefin',
        textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
              fontSize: 20,
              fontFamily: 'Josefin',
              fontWeight: FontWeight.bold,
            )),
      ),
      home: HomeScreen(),
    );
  }
}
