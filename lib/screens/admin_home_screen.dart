import 'dart:math';

import 'package:flutter/material.dart';
import 'package:votingandtallyingapp/screens/userselection_screen.dart';
import 'package:votingandtallyingapp/utils/colors_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<ElectionEvent> electionEvents = [];

  @override
  Widget build(BuildContext context) {
    final events = FirebaseFirestore.instance.collection('events');
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Home'),
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
                  'Election Events',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
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
                        final eventDate = data?['subtitle'] ?? 'No Date';

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
                            title: Text(eventName),
                            subtitle: Text(eventDate),
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final ElectionEvent? newEvent = await showDialog(
              context: context,
              builder: (context) => _CreateElectionDialog(),
            );
            if (newEvent != null) {
              setState(() {
                electionEvents.add(newEvent);
              });
            }
          },
          label: const Text(
            'Create Event',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}

class Candidate {
  final String name;
  final String position;

  Candidate({required this.name, required this.position});
}

class ElectionEvent {
  final String title;
  final String subtitle;
  List<Candidate> candidates = []; // Candidates list for each event

  ElectionEvent({required this.title, required this.subtitle});
}

class _CreateElectionDialog extends StatefulWidget {
  @override
  _CreateElectionDialogState createState() => _CreateElectionDialogState();
}

class _CreateElectionDialogState extends State<_CreateElectionDialog> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _subtitleEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Election Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleEditingController,
            decoration:
                const InputDecoration(hintText: 'Enter the event title'),
          ),
          TextField(
            controller: _subtitleEditingController,
            decoration:
                const InputDecoration(hintText: 'Enter the event subtitle'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final String title = _titleEditingController.text.trim();
            final String subtitle = _subtitleEditingController.text.trim();
            if (title.isNotEmpty && subtitle.isNotEmpty) {
              try {
                await FirebaseFirestore.instance.collection('events').add({
                  'title': title,
                  'subtitle': subtitle,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Event created successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error creating event')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter event details')),
              );
              final ElectionEvent newEvent =
                  ElectionEvent(title: title, subtitle: subtitle);
              Navigator.pop(context, newEvent);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class _AddCandidateDialog extends StatefulWidget {
  final ElectionEvent electionEvent;

  const _AddCandidateDialog({super.key, required this.electionEvent});
  @override
  _AddCandidateDialogState createState() => _AddCandidateDialogState();
}

class _AddCandidateDialogState extends State<_AddCandidateDialog> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _subtitleEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Candidate'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleEditingController,
            decoration:
                const InputDecoration(hintText: 'Enter the candidate name'),
          ),
          TextField(
            controller: _subtitleEditingController,
            decoration:
                const InputDecoration(hintText: 'Enter the candidate position'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final String title = _titleEditingController.text.trim();
            final String subtitle = _subtitleEditingController.text.trim();
            if (title.isNotEmpty && subtitle.isNotEmpty) {
              try {
                await FirebaseFirestore.instance.collection('candidates').add({
                  'name': _titleEditingController.text,
                  'position': _subtitleEditingController.text,
                  'eventname': widget.electionEvent.title,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Candidate added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding candidate')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter event details')),
              );
              final ElectionEvent newEvent =
                  ElectionEvent(title: title, subtitle: subtitle);
              Navigator.pop(context, newEvent);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class ElectionScreenAdmin extends StatefulWidget {
  final ElectionEvent electionEvent;

  const ElectionScreenAdmin({
    Key? key,
    required this.electionEvent,
  }) : super(key: key);

  @override
  _ElectionScreenAdminState createState() => _ElectionScreenAdminState();
}

class _ElectionScreenAdminState extends State<ElectionScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionEvent.title),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ElectionEvent? newEvent = await showDialog(
            context: context,
            builder: (context) => _AddCandidateDialog(
              electionEvent: widget.electionEvent,
            ),
          );
        },
        label: const Text(
          'Add candidate',
          style: TextStyle(color: Colors.white),
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
