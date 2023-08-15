import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:votingandtallyingapp/screens/userselection_screen.dart';
import 'package:votingandtallyingapp/utils/colors_utils.dart';
import 'package:votingandtallyingapp/screens/election_screen.dart';

import 'admin_home_screen.dart'; // Import the ElectionScreen

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
                        builder: (context) => ElectionScreenVoter(
                          electionEvent: ElectionEvent(
                            title: eventName,
                            subtitle: eventDescription,
                          ),
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

class ElectionScreenVoter extends StatefulWidget {
  final ElectionEvent electionEvent;
  final String election;
  final String description;

  const ElectionScreenVoter(
      {Key? key,
      required this.election,
      required this.description,
      required this.electionEvent})
      : super(key: key);

  @override
  _ElectionScreenVoterState createState() => _ElectionScreenVoterState();
}

class _ElectionScreenVoterState extends State<ElectionScreenVoter> {
  bool voted = false;
  String votedFor = '';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Electoral Candidates',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Tip: Press on the vote button to vote \nLong press on the vote button to remove your vote',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('candidates')
                    .where('eventname', isEqualTo: widget.electionEvent.title)
                    .snapshots(),
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

                      final eventName = data?['name'] ?? 'No Name';
                      final eventDate = data?['position'] ?? 'No Date';
                      final votes = data?['votes'] ?? 'No Votes';

                      return Card(
                        color: Colors.purple[300],
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ElectionScreenAdmin(
                                electionEvent: ElectionEvent(
                                  title: eventName,
                                  subtitle: eventDate,
                                ),
                              ),
                            ),
                          ),
                          title: Text('Name: $eventName'),
                          subtitle: Text('Position: $eventDate'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Votes: $votes'),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                  onLongPress: () {
                                    if (voted == false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('You have not voted'),
                                        ),
                                      );
                                    } else {
                                      if (votedFor != eventName) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'You have not voted for this candidate'),
                                          ),
                                        );
                                        return;
                                      }
                                      FirebaseFirestore.instance
                                          .collection('candidates')
                                          .doc(doc.id)
                                          .update({
                                        'votes': votes - 1,
                                      });
                                      setState(() {
                                        voted = false;
                                      });
                                    }
                                  },
                                  onPressed: () {
                                    if (voted == false) {
                                      FirebaseFirestore.instance
                                          .collection('candidates')
                                          .doc(doc.id)
                                          .update({
                                        'votes': votes + 1,
                                      });
                                      setState(() {
                                        votedFor = eventName;
                                        voted = true;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('You have already voted'),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        voted ? Colors.grey : Colors.blue[300],
                                  ),
                                  child: const Text('Vote'))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
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
