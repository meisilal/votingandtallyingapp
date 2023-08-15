import 'package:flutter/material.dart';
import 'package:votingandtallyingapp/screens/userselection_screen.dart';
import 'package:votingandtallyingapp/screens/add_candidates_screen.dart';
import 'package:votingandtallyingapp/utils/colors_utils.dart';

class ElectionScreen extends StatefulWidget {
  final String election;
  final String description;

  const ElectionScreen(
      {Key? key, required this.election, required this.description})
      : super(key: key);

  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  bool isElectionStarted =
      false; // Track whether the election has started or not

  void startElection() {
    setState(() {
      isElectionStarted = true;
    });
  }

  void endElection() {
    setState(() {
      isElectionStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.election),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.description,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isElectionStarted ? null : startElection,
                child: const Text('Start Election'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: isElectionStarted ? endElection : null,
                child: const Text('End Election'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCandidatesScreen(
                        election: widget.election,
                      ),
                    ),
                  );
                },
                child: const Text('Add Candidates'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const LogoutButton(),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserSelectionScreen()),
        );
      },
      child: const Text('Logout'),
    );
  }
}
