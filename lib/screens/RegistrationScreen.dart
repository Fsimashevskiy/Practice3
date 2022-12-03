//import 'package:dartz/dartz.dart';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as wgt;
import 'package:flutter_auth/data/repositories/auth_repository_implementation.dart';
import 'package:flutter_auth/domain/usecases/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/AdminScreen.dart';
import 'package:flutter_auth/screens/UserScreen.dart';
import '../domain/entity/role_entity.dart';
import 'AuthScreen.dart';

class RegistationScreen extends StatefulWidget {
  const RegistationScreen({super.key});

  @override
  wgt.State<StatefulWidget> createState() => RegistationScreenState();
}

class RegistationScreenState extends wgt.State<RegistationScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        body: Column(
          children: [
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                        child: TextFormField(
                          controller: loginController,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "The field must not be empty";
                            }
                            if (value.length < 5) {
                              return "The field must have at least 5 characters";
                            }
                            if (value.length > 12) {
                              return "The field must have no more than 12 characters";
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: "login", border: OutlineInputBorder()),
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value == "") {
                            return "he field must not be empty";
                          }
                          if (value.length < 5) {
                            return "The field must have at least 5 characters";
                          }
                          if (value.length > 20) {
                            return "The field must have no more than 12 characters";
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return "Password must have at least one uppercase latin letter";
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return "Password must have at least one number";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "password", border: OutlineInputBorder()),
                      )
                    ],
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;

                        String login = loginController.text;
                        String password = passwordController.text;

                        Future<Either<String, bool>> result =
                            AuthRepositoryImplementation()
                                .checkLoginExists(login);
                        bool loginExitsts = false;
                        result.then((value) {
                          if (value.isRight()) {
                            final snackBar = SnackBar(
                                content: Text("This user already exists"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar =
                                SnackBar(content: Text("registration error"));

                            String hashPass =
                                md5.convert(utf8.encode(password)).toString();
                            Future<Either<String, bool>> result =
                                AuthRepositoryImplementation()
                                    .signUp(login, hashPass);

                            result.then((value) {
                              if (value.isRight()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AuthScreen()));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            });
                          }
                        });
                      },
                      child: const Text(
                        "Registration",
                        style: TextStyle(fontSize: 50),
                        selectionColor: Colors.green,
                      )),
                ),
                ElevatedButton(
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen()))
                        },
                    child: const Text(
                      "Back",
                      style: TextStyle(fontSize: 50),
                      selectionColor: Colors.green,
                    )),
              ],
            ),
            Expanded(child: Container()),
          ],
        ));
  }
}
