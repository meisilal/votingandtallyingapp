import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:votingandtallyingapp/screens/userselection_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xffcb2b93),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        primarySwatch: Colors.blue,
      ),
      home: const UserSelectionScreen(),
    );
  }
}
