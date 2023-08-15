// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votingandtallyingapp/screens/voter_home_screen.dart';
import 'package:votingandtallyingapp/reusable_widget/reusable_widget.dart';
import 'package:votingandtallyingapp/utils/colors_utils.dart';

enum UserType {
  Voter,
  Candidate,
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  UserType _selectedUserType = UserType.Voter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Register",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/vote.png"),
                const SizedBox(
                  height: 30,
                ),
                DropdownButtonFormField<UserType>(
                  value: _selectedUserType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedUserType = newValue!;
                    });
                  },
                  items: UserType.values.map((UserType userType) {
                    return DropdownMenuItem<UserType>(
                      value: userType,
                      child: Text(userType.toString().split('.').last),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Username", Icons.person_outline, false,
                    _usernameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email id", Icons.lock_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                vat_button(context, "Register", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    print("Created New Account");
                    if (_selectedUserType == UserType.Voter) {
                      // Handle voter registration
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VoterHomeScreen(),
                        ),
                      );
                    } else if (_selectedUserType == UserType.Candidate) {
                      // Handle candidate registration
                      // Add navigation to candidate home screen
                    }
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
