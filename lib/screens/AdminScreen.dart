import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'AuthScreen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AdminScreenState();
  }
}

class AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("ADMIN STYLE", style: TextStyle(fontSize: 50)),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AuthScreen()));
                },
                child: const Text(
                  "Go out",
                  style: TextStyle(fontSize: 50),
                  selectionColor: Colors.green,
                ))
          ],
        ),
      ]),
    );
  }
}
