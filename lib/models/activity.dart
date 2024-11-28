// lib/models/activity.dart

class Activity {
  final String name;
  final String timeRange;
  final String imageUrl;
  final String? description;
  final String? location;

  Activity({
    required this.name,
    required this.timeRange,
    required this.imageUrl,
    this.description,
    this.location,
  });

  Activity copyWith({
    String? name,
    String? timeRange,
    String? imageUrl,
    String? description,
    String? location,
  }) {
    return Activity(
      name: name ?? this.name,
      timeRange: timeRange ?? this.timeRange,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      location: location ?? this.location,
    );
  }
}
