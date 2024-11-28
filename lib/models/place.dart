// lib/models/place.dart

class Place {
  final String id;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final double? rating;
  final double price;
  final String type;
  final String category;
  final String? weather;
  final String? timeZone;
  final String? arrival;
  final int? reviewCount;
  final double latitude;
  final double longitude;
  final String? duration;
  final double? distance;

  Place(
      {required this.id,
      required this.title,
      required this.description,
      required this.location,
      required this.latitude,
      required this.longitude,
      required this.imageUrl,
      this.rating,
      required this.price,
      required this.type,
      required this.category,
      this.weather,
      this.timeZone,
      this.arrival,
      this.reviewCount,
      this.duration,
      this.distance});

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'],
      type: map['type'],
      rating: map['rating']?.toDouble(),
      reviewCount: map['reviewCount'],
      price: map['price']?.toDouble(),
      duration: map['duration'],
      category: map['category'],
      weather: map['weather'],
      timeZone: map['timeZone'],
      arrival: map['arrival'],
    );
  }
}
