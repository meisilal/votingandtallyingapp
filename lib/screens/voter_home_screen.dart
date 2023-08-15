import 'package:flutter/material.dart';
import 'package:votingandtallyingapp/screens/userselection_screen.dart';
import 'package:votingandtallyingapp/utils/colors_utils.dart';
import 'package:votingandtallyingapp/screens/election_screen.dart'; // Import the ElectionScreen

class VoterHomeScreen extends StatefulWidget {
  const VoterHomeScreen({Key? key}) : super(key: key);

  @override
  State<VoterHomeScreen> createState() => _VoterHomeScreenState();
}

class _VoterHomeScreenState extends State<VoterHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Election Events'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: const Text('Election 1'),
              subtitle: const Text('School of Computing and Informatics'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ElectionScreen(
                      election: 'Election 1',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Election 2'),
              subtitle: const Text('School of Health Sciences'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ElectionScreen(
                      election: 'Election 2',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Election 3'),
              subtitle: const Text('College of Humanities and Social Sciences'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ElectionScreen(
                      election: 'Election 3',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen (UserSelectionScreen)
            },
            child: const Text('Back to Selection'),
          ),
          const SizedBox(width: 16), // Add some spacing between the buttons
          const LogoutButton(), // Add the LogoutButton to the bottomNavigationBar
        ],
      ),
    );
  }
}

class ElectionScreen extends StatefulWidget {
  final String election;

  const ElectionScreen({Key? key, required this.election}) : super(key: key);

  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.election),
      ),
      body: Center(
        child: Text(widget.election),
      ),
      bottomNavigationBar: const LogoutButton(), // Add the LogoutButton to the bottomNavigationBar
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
