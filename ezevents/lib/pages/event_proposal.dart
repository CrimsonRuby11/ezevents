import 'package:flutter/material.dart';

void main() {
  runApp(EventProposal());
}

class EventProposal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventProposalPage(),
    );
  }
}

class EventProposalPage extends StatefulWidget {
  @override
  _EventProposalPageState createState() => _EventProposalPageState();
}

class _EventProposalPageState extends State<EventProposalPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  void _proposeEvent() {

    final eventName = _eventNameController.text;
    final clubName = _clubNameController.text;
    final eventDescription = _eventDescriptionController.text;
    final time = _timeController.text;
    if (eventName.isEmpty || clubName.isEmpty || eventDescription.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill out all fields!")),
      );
    } else {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Event Proposal Submitted'),
            content: Text(
                'Event: $eventName\nClub: $clubName\nDescription: $eventDescription'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();

                  _eventNameController.clear();
                  _clubNameController.clear();
                  _eventDescriptionController.clear();
                  _timeController.clear();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Proposal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Event Name Input
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Club Name Input
            TextField(
              controller: _clubNameController,
              decoration: InputDecoration(
                labelText: 'Club Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Event Description Input
            TextField(
              controller: _eventDescriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Event Description',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Timings in 24 hr format (e.g. 1400 - 1800)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      // Floating action button to propose the event
      floatingActionButton: FloatingActionButton(
        onPressed: _proposeEvent,
        tooltip: 'Propose Event',
        child: Icon(Icons.send),
      ),
    );
  }
}
