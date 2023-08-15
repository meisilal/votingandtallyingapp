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
          child: ListView.builder(
          itemCount: electionEvents.length,
          itemBuilder: (context, index) {
            final ElectionEvent event = electionEvents[index];
            return ListTile(
              title: Text(event.title),
              subtitle: Text(event.subtitle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ElectionScreen(
                      electionEvent: event,
                    ),
                  ),
                );
              },
            );
          },
        ),
     ),
      floatingActionButton: FloatingActionButton(
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
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8), // Adjust the value as needed
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      color: Theme.of(context).colorScheme.secondary,
      child: Text(
        'Create Event',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
)
    );
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
  final TextEditingController _subtitleEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Election Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleEditingController,
            decoration: const InputDecoration(hintText: 'Enter the event title'),
          ),
          TextField(
            controller: _subtitleEditingController,
            decoration: const InputDecoration(hintText: 'Enter the event subtitle'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final String title = _titleEditingController.text.trim();
            final String subtitle = _subtitleEditingController.text.trim();
            if (title.isNotEmpty && subtitle.isNotEmpty) {
              final ElectionEvent newEvent = ElectionEvent(title: title, subtitle: subtitle);
              Navigator.pop(context, newEvent);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class ElectionScreen extends StatefulWidget {
  final ElectionEvent electionEvent;

  const ElectionScreen({
    Key? key,
    required this.electionEvent,
  }) : super(key: key);

  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  final TextEditingController _candidateNameController = TextEditingController();
  final TextEditingController _candidatePositionController = TextEditingController();

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.electionEvent.title),
            SizedBox(height: 20),
            Text('Candidates: ${widget.electionEvent.candidates.length}'),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.electionEvent.candidates.length,
              itemBuilder: (context, index) {
                final candidate = widget.electionEvent.candidates[index];
                return ListTile(
                  title: Text(candidate.name),
                  subtitle: Text(candidate.position),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        widget.electionEvent.candidates.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _candidateNameController,
              decoration: InputDecoration(labelText: 'Candidate Name'),
            ),
            TextField(
              controller: _candidatePositionController,
              decoration: InputDecoration(labelText: 'Candidate Position'),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = _candidateNameController.text.trim();
                final String position = _candidatePositionController.text.trim();
                if (name.isNotEmpty && position.isNotEmpty) {
                  bool candidateExists = widget.electionEvent.candidates.any((candidate) => candidate.name.toLowerCase() == name.toLowerCase());

                  if (candidateExists) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Candidate Already Exists'),
                        content: Text('A candidate with the same name already exists.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    setState(() {
                      widget.electionEvent.candidates.add(Candidate(name: name, position: position));
                      _candidateNameController.clear();
                      _candidatePositionController.clear();
                    });
                  }
                }
              },
              child: Text('Add Candidate'),
            ),
          ],
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
