import 'package:flutter/material.dart';
void main() {
  runApp(EventProposal());
}

class EventProposal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Proposal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: eventList(),
    );
  }
}
