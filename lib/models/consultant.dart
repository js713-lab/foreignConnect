// lib/models/consultant.dart

class Consultant {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double pricePerHour;
  final double pricePerDay;
  final String joinedTime;
  final String nextAvailable;
  final bool isFavorite;
  final int likesCount;
  final int clientsCount;
  final List<String> services;
  final List<Review> reviews;

  Consultant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.joinedTime,
    required this.nextAvailable,
    this.isFavorite = false,
    this.likesCount = 0,
    this.clientsCount = 0,
    this.services = const [],
    this.reviews = const [],
  });
}

class Review {
  final String userId;
  final String comment;
  final String userImage;

  Review({
    required this.userId,
    required this.comment,
    required this.userImage,
  });
}
