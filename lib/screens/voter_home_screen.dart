import 'package:cloud_firestore/cloud_firestore.dart';
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
    final events = FirebaseFirestore.instance.collection('events');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Election Events'),
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
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: events.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot<Map<String, dynamic>> doc) {
                final data = doc.data();
                final eventName = data?['title'] ?? 'No Name';
                final eventDescription = data?['subtitle'] ?? 'No Date';

                return Card(
                  color: Colors.purple[300],
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectionScreen(
                          election: eventName,
                          description: eventDescription,
                        ),
                      ),
                    ),
                    title: Text(eventName),
                    subtitle: Text(eventDescription),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                  context); // Navigate back to the previous screen (UserSelectionScreen)
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
  final String description;

  const ElectionScreen(
      {Key? key, required this.election, required this.description})
      : super(key: key);

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
        child: Text(widget.description),
      ),
      bottomNavigationBar:
          const LogoutButton(), // Add the LogoutButton to the bottomNavigationBar
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
