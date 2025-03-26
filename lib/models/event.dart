class Event {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final DateTime date;

  Event({
    required this.title,
    required this.startDate,
    required this.endDate,
    this.location,
    DateTime? date,
  }) : date = date ?? startDate;
}
