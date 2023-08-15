import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votingandtallyingapp/reusable_widget/reusable_widget.dart';
import 'package:votingandtallyingapp/screens/voter_home_screen.dart';
import 'package:votingandtallyingapp/screens/register_screen.dart';
import 'package:votingandtallyingapp/screens/reset_password.dart';
import 'package:votingandtallyingapp/utils/colors_utils.dart';

class VoterLoginScreen extends StatefulWidget {
  const VoterLoginScreen({super.key});

  @override
  State<VoterLoginScreen> createState() => _VoterLoginScreenState();
}

class _VoterLoginScreenState extends State<VoterLoginScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ 
      hexStringToColor("CB2B93"),
      hexStringToColor("9546C4"),
      hexStringToColor("5E61F4")
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              logoWidget("assets/images/vote.png"),
              const SizedBox(
                height: 30,
              ),
              reusableTextField("Enter Username", Icons.person_outline, false, _emailTextController),

              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
              const SizedBox(
                height: 5,
              ),
              forgetPassword(context),
              vat_button(context, "Log In", () {
                FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _emailTextController.text, 
                  password: _passwordTextController.text).then((value) {
                    Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const VoterHomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
              }),
              registerOption()
            ],
            ),
          ),
          ),
        ),
      );
  }

  Row registerOption()  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account?", 
        style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => const RegisterScreen()));
          },
          child: const Text(
            " Register", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
      ],
    );
  }

  Widget forgetPassword(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
          ),
          onPressed: () => Navigator.push(context, 
          MaterialPageRoute(builder: (context) => const ResetPassword())),
        ),
      );
    }
}
