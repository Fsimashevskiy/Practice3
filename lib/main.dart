import 'package:flutter/material.dart';
import 'package:flutter_auth/core/db/data_base_helper.dart';
import 'package:flutter_auth/screens/AuthScreen.dart';
import 'package:flutter_auth/screens/UserScreen.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  DataBaseHelper.instance.init().whenComplete(() {
    runApp(const App());
  });
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
