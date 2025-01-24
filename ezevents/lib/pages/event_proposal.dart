import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventProposalPage extends StatefulWidget {
  final String uid;

  const EventProposalPage({super.key, required this.uid});

  @override
  _EventProposalPageState createState() => _EventProposalPageState();
}

class _EventProposalPageState extends State<EventProposalPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();

  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  DateTime? selectedDate;

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

  // Function to show DatePicker for event date selection
  void _showDatePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
    );

    if (newDate != null && newDate != selectedDate) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }

  // Function to propose the event
  void _proposeEvent() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sending Event Proposal...")),
    );

    final eventName = _eventNameController.text;
    final clubName = _clubNameController.text;
    final eventDescription = _eventDescriptionController.text;

    // Check if the required fields are filled
    if (eventName.isEmpty ||
        clubName.isEmpty ||
        eventDescription.isEmpty ||
        _fromTime == null ||
        _toTime == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill out all fields!")),
      );
    } else {
      final firestore = FirebaseFirestore.instance;

      try {
        final result = await firestore.collection('events').add({
          'eventName': eventName,
          'clubName': clubName,
          'eventDesc': eventDescription,
          'date': DateFormat("dd/MM/yyyy").format(selectedDate!),
          'fromTime': _fromTime!.hour.toString(),
          'toTime': _toTime!.minute.toString(),
          'uid': widget.uid,
        });

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Event Proposal Submitted'),
              content: Text(
                  'Event: $eventName\nClub: $clubName\nDescription: $eventDescription\nDate: ${selectedDate?.toLocal().toString().split(' ')[0]}\nTime: ${_fromTime?.format(context)} - ${_toTime?.format(context)}'),
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
                      selectedDate = null;
                    });
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An Error occured...")),
        );
      }
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

            // Date Picker
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(selectedDate == null
                        ? 'Select Event Date'
                        : 'Event Date: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
                    onTap: _showDatePicker,
                    trailing: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // From Time Picker
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(
                        'From Time: ${_fromTime?.format(context) ?? 'Not selected'}'),
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
                    title: Text(
                        'To Time: ${_toTime?.format(context) ?? 'Not selected'}'),
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
