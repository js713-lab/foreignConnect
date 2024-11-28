// lib/data/cart_data.dart

class CartData {
  static List<Map<String, dynamic>> getDummyCartItems() {
    return [
      {
        'type': 'consultant',
        'id': '1',
        'name': 'Makabaka',
        'image': 'assets/images/consultants/consultant_1.jpg',
        'priceHour': 10.0,
        'priceDay': 110.0,
        'selectedTimes': ['24 Feb 2024 3:00pm', '24 Feb 2024 4:00pm'],
        'quantity': 2,
        'isSelected': true,
      },
      {
        'type': 'consultant',
        'id': '2',
        'name': 'Usidisi',
        'image': 'assets/images/consultants/consultant_2.jpg',
        'priceHour': 8.0,
        'priceDay': 100.0,
        'selectedTimes': ['28 Feb 2024 2:00pm'],
        'quantity': 1,
        'isSelected': false,
      },
      {
        'type': 'tour_package',
        'id': '3',
        'title': '3D2N SG Tour Packages',
        'image': 'assets/images/singapore_1.jpg',
        'price': 250.0,
        'selectedTimes': ['28 Feb 2024'],
        'quantity': 1,
        'isSelected': false,
      },
    ];
  }

  static List<Map<String, dynamic>> getTourPackages() {
    return [
      {
        'title': '3D2N SG Tour Package',
        'image': 'assets/images/singapore_1.jpg',
        'joined': '2yrs ago',
        'rating': 4.0,
        'reviews': 36,
        'priceHour': 10.0,
        'priceDay': 110.0,
        'nextAvailable': '10:00 tomorrow',
        'isFavorite': true,
      },
      {
        'title': '3D2N SG Tour Package',
        'image': 'assets/images/singapore_2.jpg',
        'joined': '1yrs ago',
        'rating': 4.4,
        'reviews': 18,
        'priceHour': 8.0,
        'priceDay': 100.0,
        'nextAvailable': '14:00 tomorrow',
        'isFavorite': false,
      },
      {
        'title': '3D2N SG Tour Package',
        'image': 'assets/images/singapore_3.jpg',
        'joined': '4yrs ago',
        'rating': 4.0,
        'reviews': 48,
        'priceHour': 10.0,
        'priceDay': 110.0,
        'nextAvailable': '4 December 2024',
        'isFavorite': true,
      },
    ];
  }
}
