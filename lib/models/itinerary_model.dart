// lib/models/itinerary_model.dart

class Itinerary {
  final String destination;
  final String purpose;
  final int days;
  final int nights;
  final List<DayPlan> dayPlans;
  final String imageUrl;

  Itinerary({
    required this.destination,
    required this.purpose,
    required this.days,
    required this.nights,
    this.dayPlans = const [],
    required this.imageUrl,
  });
}

class DayPlan {
  final int day;
  final List<Activity> activities;

  DayPlan({required this.day, this.activities = const []});
}

class Activity {
  final String name;
  final String timeRange;
  final String? imageUrl;

  Activity({required this.name, required this.timeRange, this.imageUrl});
}
