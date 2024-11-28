// lib/models/day_plan.dart

import 'activity.dart';

class DayPlan {
  final int day;
  final List<Activity> activities;

  DayPlan({
    required this.day,
    required this.activities,
  });

  DayPlan copyWith({
    int? day,
    List<Activity>? activities,
  }) {
    return DayPlan(
      day: day ?? this.day,
      activities: activities ?? this.activities,
    );
  }
}
