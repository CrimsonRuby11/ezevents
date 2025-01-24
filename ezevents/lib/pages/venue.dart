class Venue {
  final String name;
  bool isAvailable;
  final List<DateTime> unavailableDates;

  Venue({
    required this.name,
    this.isAvailable = true,
    this.unavailableDates = const [],
  });


  bool checkAvailability(DateTime date) {
    return isAvailable && !unavailableDates.contains(date);
  }
}

