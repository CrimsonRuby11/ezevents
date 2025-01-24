import 'package:flutter/material.dart';
import 'venue.dart';

void main() {
  runApp(VenueBooking());
}

class VenueBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venue Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VenueListPage(),
    );
  }
}

class VenueListPage extends StatefulWidget {
  @override
  _VenueListPageState createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  final List<Venue> venues = [
    Venue(name: 'Rajaji Hall', isAvailable: true, unavailableDates: [DateTime(2025, 1, 25)]),
    Venue(name: 'Ambedkar Auditorium', isAvailable: false),
    Venue(name: 'Sarojini Naidu Gallery', isAvailable: true),
    Venue(name: 'Kamaraj Auditorium', isAvailable: true, unavailableDates: [DateTime(2025, 1, 27)]),
    Venue(name: 'Channa Reddy Auditorium', isAvailable: true, unavailableDates: [DateTime(2025, 1, 24)]),
    Venue(name: 'Anna Auditorium', isAvailable: false),
    Venue(name: 'Homi Bhabha Gallery', isAvailable: true, unavailableDates: [DateTime(2025, 1, 26)]),
    Venue(name: 'TT VOC Gallery', isAvailable: false)
  ];

  DateTime selectedDate = DateTime.now();

  // Function to open date picker and let the user choose a date
  void _showDatePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (newDate != null && newDate != selectedDate) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }

  // Function to show the booking request confirmation dialog
  void _sendBookingRequest(Venue venue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Request'),
          content: Text('You have sent a booking request for ${venue.name} on ${selectedDate.toLocal()}'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Venues')),
      body: Column(
        children: [
          // Date picker section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selected Date: ${selectedDate.toLocal()}'.split(' ')[0],  // Format the date
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _showDatePicker,  // Trigger date picker on tap
                ),
              ],
            ),
          ),

          // Venue List section
          Expanded(
            child: ListView.builder(
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final venue = venues[index];
                final isAvailableOnSelectedDate = venue.checkAvailability(selectedDate);
                return ListTile(
                  title: Text(venue.name),
                  tileColor: isAvailableOnSelectedDate ? Colors.green : Colors.red,
                  subtitle: isAvailableOnSelectedDate
                      ? Text('Available on ${selectedDate.toLocal()}')
                      : Text('Not available on ${selectedDate.toLocal()}'),
                  onTap: isAvailableOnSelectedDate
                      ? () => _sendBookingRequest(venue)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
