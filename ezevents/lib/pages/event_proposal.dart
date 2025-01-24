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

  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

  // Function to show the time picker for the "From" time
  void _selectFromTime(BuildContext context) async {
    final TimeOfDay? selectedFromTime = await showTimePicker(
      context: context,
      initialTime: _fromTime ?? TimeOfDay(hour: 9, minute: 0),
    );
    if (selectedFromTime != null) {
      setState(() {
        _fromTime = selectedFromTime;
      });
    }
  }

  // Function to show the time picker for the "To" time
  void _selectToTime(BuildContext context) async {
    final TimeOfDay? selectedToTime = await showTimePicker(
      context: context,
      initialTime: _toTime ?? TimeOfDay(hour: 17, minute: 0),
    );
    if (selectedToTime != null) {
      setState(() {
        _toTime = selectedToTime;
      });
    }
  }

  // Function to propose the event
  void _proposeEvent() {
    final eventName = _eventNameController.text;
    final clubName = _clubNameController.text;
    final eventDescription = _eventDescriptionController.text;

    // Check if the required fields are filled
    if (eventName.isEmpty || clubName.isEmpty || eventDescription.isEmpty || _fromTime == null || _toTime == null) {
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
                'Event: $eventName\nClub: $clubName\nDescription: $eventDescription\nTime: ${_fromTime?.format(context)} - ${_toTime?.format(context)}'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Clear all fields
                  _eventNameController.clear();
                  _clubNameController.clear();
                  _eventDescriptionController.clear();
                  setState(() {
                    _fromTime = null;
                    _toTime = null;
                  });
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
            SizedBox(height: 20),

            // From Time Picker
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text('From Time: ${_fromTime?.format(context) ?? 'Not selected'}'),
                    onTap: () => _selectFromTime(context),
                    trailing: Icon(Icons.access_time),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // To Time Picker
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text('To Time: ${_toTime?.format(context) ?? 'Not selected'}'),
                    onTap: () => _selectToTime(context),
                    trailing: Icon(Icons.access_time),
                  ),
                ),
              ],
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
