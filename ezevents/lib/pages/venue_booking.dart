import 'package:flutter/material.dart';


class Venue {
  final String name;
  final bool isAvailable;
  final List<DateTime> unavailableDates;
  final List<Map<String, TimeOfDay>> unavailableTimes;

  Venue({
    required this.name,
    required this.isAvailable,
    this.unavailableDates = const [],
    this.unavailableTimes = const [],
  });


  bool checkAvailability(DateTime date, TimeOfDay fromTime, TimeOfDay toTime) {

    if (!isAvailable) return false;

    // Check for unavailable dates
    for (var unavailableDate in unavailableDates) {
      if (unavailableDate.year == date.year &&
          unavailableDate.month == date.month &&
          unavailableDate.day == date.day) {
        return false;
      }
    }

    // Check for unavailable times
    for (var unavailableTime in unavailableTimes) {
      // Compare with the from and to times
      var unavailableFrom = unavailableTime["from"]!;
      var unavailableTo = unavailableTime["to"]!;
      if (isTimeConflict(fromTime, toTime, unavailableFrom, unavailableTo)) {
        return false;
      }
    }

    return true;
  }

  // Check if the times overlap
  bool isTimeConflict(TimeOfDay from, TimeOfDay to, TimeOfDay unavailableFrom, TimeOfDay unavailableTo) {
    // Convert TimeOfDay to DateTime to compare
    DateTime fromDateTime = DateTime(2025, 1, 1, from.hour, from.minute);
    DateTime toDateTime = DateTime(2025, 1, 1, to.hour, to.minute);
    DateTime unavailableFromDateTime = DateTime(2025, 1, 1, unavailableFrom.hour, unavailableFrom.minute);
    DateTime unavailableToDateTime = DateTime(2025, 1, 1, unavailableTo.hour, unavailableTo.minute);

    return (fromDateTime.isBefore(unavailableToDateTime) && toDateTime.isAfter(unavailableFromDateTime));
  }
}

void main() {
  runApp(VenueBooking());
}

class VenueBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VenueListPage(),
    );
  }
}

class VenueListPage extends StatefulWidget {
  @override
  _VenueListPageState createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  final List<Venue> venues = [
    Venue(
        name: 'Rajaji Hall',
        isAvailable: true,
        unavailableDates: [DateTime(2025, 1, 25)],
        unavailableTimes: [
          {"from": TimeOfDay(hour: 10, minute: 0), "to": TimeOfDay(hour: 12, minute: 0)}
        ]),
    Venue(name: 'Ambedkar Auditorium', isAvailable: false),
    Venue(name: 'Sarojini Naidu Gallery', isAvailable: true),
    Venue(name: 'Kamaraj Auditorium', isAvailable: true, unavailableDates: [DateTime(2025, 1, 27)]),
    Venue(name: 'Channa Reddy Auditorium', isAvailable: true, unavailableDates: [DateTime(2025, 1, 24)]),
    Venue(name: 'Anna Auditorium', isAvailable: false),
    Venue(name: 'Homi Bhabha Gallery', isAvailable: true, unavailableDates: [DateTime(2025, 1, 26)]),
    Venue(name: 'TT VOC Gallery', isAvailable: false)
  ];

  DateTime? selectedDate;
  TimeOfDay? selectedFromTime;
  TimeOfDay? selectedToTime;

  // Show the date picker
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

  // Show the "from" time picker
  void _showFromTimePicker() async {
    TimeOfDay? newFromTime = await showTimePicker(
      context: context,
      initialTime: selectedFromTime ?? TimeOfDay(hour: 9, minute: 0),
    );

    if (newFromTime != null && newFromTime != selectedFromTime) {
      setState(() {
        selectedFromTime = newFromTime;
      });
    }
  }

  // Show the "to" time picker
  void _showToTimePicker() async {
    TimeOfDay? newToTime = await showTimePicker(
      context: context,
      initialTime: selectedToTime ?? TimeOfDay(hour: 10, minute: 0),
    );

    if (newToTime != null && newToTime != selectedToTime) {
      setState(() {
        selectedToTime = newToTime;
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
          content: Text(
              'You have sent a booking request for ${venue.name} on ${selectedDate?.toLocal()} from ${selectedFromTime?.format(context)} to ${selectedToTime?.format(context)}'),
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
                  'Selected Date: ${selectedDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}', // Format the date
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _showDatePicker, // Trigger date picker on tap
                ),
              ],
            ),
          ),
          // From Time Picker Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'From Time: ${selectedFromTime?.format(context) ?? 'Not selected'}',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: _showFromTimePicker, // Trigger from time picker on tap
                ),
              ],
            ),
          ),
          // To Time Picker Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'To Time: ${selectedToTime?.format(context) ?? 'Not selected'}',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: _showToTimePicker, // Trigger to time picker on tap
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
                final isAvailableOnSelectedDate = selectedDate != null &&
                    selectedFromTime != null &&
                    selectedToTime != null &&
                    venue.checkAvailability(selectedDate!, selectedFromTime!, selectedToTime!);
                return ListTile(
                  title: Text(venue.name),
                  tileColor: isAvailableOnSelectedDate ? Colors.green : Colors.red,
                  subtitle: isAvailableOnSelectedDate
                      ? Text('Available on ${selectedDate?.toLocal()} from ${selectedFromTime?.format(context)} to ${selectedToTime?.format(context)}')
                      : Text('Not available on ${selectedDate?.toLocal()} from ${selectedFromTime?.format(context)} to ${selectedToTime?.format(context)}'),
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
