import 'package:flutter/material.dart';
import 'package:votingandtallyingapp/screens/userselection_screen.dart';
import 'package:votingandtallyingapp/utils/colors_utils.dart';

class AddCandidatesScreen extends StatefulWidget {
  final String election;

  const AddCandidatesScreen({Key? key, required this.election}) : super(key: key);

  @override
  _AddCandidatesScreenState createState() => _AddCandidatesScreenState();
}

class _AddCandidatesScreenState extends State<AddCandidatesScreen> {
  List<String> candidates = []; // List to store the added candidates

  TextEditingController _candidateNameController = TextEditingController();

  void addCandidate() {
    String candidateName = _candidateNameController.text.trim();
    if (candidateName.isNotEmpty) {
      setState(() {
        candidates.add(candidateName);
      });
      _candidateNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Candidates'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Election: ${widget.election}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _candidateNameController,
                decoration: InputDecoration(
                  labelText: 'Candidate Name',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: addCandidate,
                child: const Text('Add Candidate'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: candidates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        candidates[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
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
