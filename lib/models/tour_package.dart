// lib/models/tour_package.dart

class TourPackage {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviews;
  final double pricePerHour;
  final double pricePerDay;
  final String joinedDate;
  final bool isFavorite;
  final DateTime nextAvailable;

  TourPackage({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.joinedDate,
    required this.isFavorite,
    required this.nextAvailable,
  });
}
