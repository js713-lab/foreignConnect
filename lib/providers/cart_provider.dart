// lib/providers/cart_provider.dart

import 'package:flutter/foundation.dart';
import '../data/cart_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];
  final String _prefsKey = 'cart_items';

  CartProvider() {
    _loadItems();
  }

  // Getters
  List<Map<String, dynamic>> get items => _items;
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  // Calculate total for selected items
  double get selectedItemsTotal {
    return _items.fold(0.0, (sum, item) {
      if (item['isSelected'] ?? false) {
        if (item['type'] == 'consultant') {
          // For consultants, multiply hourly rate by number of time slots
          final hourlyRate = (item['priceHour'] as num?)?.toDouble() ?? 0.0;
          final slots = (item['selectedTimes'] as List?)?.length ?? 1;
          final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
          return sum + (hourlyRate * slots * quantity);
        } else {
          // For tour packages, use the package price
          final price = (item['priceDay'] as num?)?.toDouble() ?? 0.0;
          final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
          return sum + (price * quantity);
        }
      }
      return sum;
    });
  }

  int get selectedItemCount {
    return _items.where((item) => item['isSelected'] ?? false).length;
  }

  bool get areAllItemsSelected {
    return _items.isNotEmpty &&
        _items.every((item) => item['isSelected'] ?? false);
  }

  // Load items from SharedPreferences
  Future<void> _loadItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? itemsJson = prefs.getString(_prefsKey);

      if (itemsJson != null) {
        final List<dynamic> decodedItems = json.decode(itemsJson);
        _items = List<Map<String, dynamic>>.from(decodedItems);
      } else {
        // Load dummy data if no saved data exists
        _items = CartData.getDummyCartItems();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart items: $e');
      // Load dummy data as fallback
      _items = CartData.getDummyCartItems();
      notifyListeners();
    }
  }

  // Save items to SharedPreferences
  Future<void> _saveItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String itemsJson = json.encode(_items);
      await prefs.setString(_prefsKey, itemsJson);
    } catch (e) {
      debugPrint('Error saving cart items: $e');
    }
  }

  // Add item to cart with validation
  Future<void> addItem(Map<String, dynamic> item) async {
    try {
      // Validate required fields
      if (!_validateItem(item)) {
        throw Exception('Invalid item data: Missing required fields');
      }

      // Check for duplicate items
      final existingIndex = _items.indexWhere((i) => i['id'] == item['id']);

      if (existingIndex >= 0) {
        // Update quantity if item exists
        _items[existingIndex]['quantity'] =
            (_items[existingIndex]['quantity'] ?? 1) + 1;
      } else {
        // Ensure required fields have default values
        final normalizedItem = {
          ...item,
          'quantity': 1,
          'isSelected': false,
          'selectedTimes': item['selectedTimes'] ?? [],
        };
        _items.add(normalizedItem);
      }

      notifyListeners();
      await _saveItems();
    } catch (e) {
      debugPrint('Error adding item to cart: $e');
      rethrow;
    }
  }

  // Validate item data
  bool _validateItem(Map<String, dynamic> item) {
    final requiredFields = ['id', 'type'];
    final hasRequiredFields = requiredFields.every(item.containsKey);

    if (!hasRequiredFields) return false;

    // Type-specific validation
    if (item['type'] == 'consultant') {
      return item.containsKey('name') &&
          item.containsKey('priceHour') &&
          item.containsKey('image');
    } else {
      return item.containsKey('title') &&
          item.containsKey('priceDay') &&
          item.containsKey('image');
    }
  }

  // Remove item from cart
  Future<void> removeItem(Map<String, dynamic> item) async {
    try {
      _items.removeWhere((i) => i['id'] == item['id']);
      notifyListeners();
      await _saveItems();
    } catch (e) {
      debugPrint('Error removing item from cart: $e');
      rethrow;
    }
  }

  // Update item quantity
  Future<void> updateQuantity(Map<String, dynamic> item, int quantity) async {
    try {
      if (quantity < 1) throw Exception('Quantity must be greater than 0');

      final index = _items.indexWhere((i) => i['id'] == item['id']);
      if (index >= 0) {
        _items[index]['quantity'] = quantity;
        notifyListeners();
        await _saveItems();
      }
    } catch (e) {
      debugPrint('Error updating quantity: $e');
      rethrow;
    }
  }

  // Toggle item selection
  Future<void> toggleItemSelection(Map<String, dynamic> item) async {
    try {
      final index = _items.indexWhere((i) => i['id'] == item['id']);
      if (index >= 0) {
        _items[index]['isSelected'] = !(_items[index]['isSelected'] ?? false);
        notifyListeners();
        await _saveItems();
      }
    } catch (e) {
      debugPrint('Error toggling item selection: $e');
      rethrow;
    }
  }

  // Toggle all items selection
  Future<void> toggleSelectAll(bool value) async {
    try {
      for (var item in _items) {
        item['isSelected'] = value;
      }
      notifyListeners();
      await _saveItems();
    } catch (e) {
      debugPrint('Error toggling select all: $e');
      rethrow;
    }
  }

  // Remove selected items
  Future<void> removeSelectedItems() async {
    try {
      _items.removeWhere((item) => item['isSelected'] ?? false);
      notifyListeners();
      await _saveItems();
    } catch (e) {
      debugPrint('Error removing selected items: $e');
      rethrow;
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      _items.clear();
      notifyListeners();
      await _saveItems();
    } catch (e) {
      debugPrint('Error clearing cart: $e');
      rethrow;
    }
  }

  // Update time slot at specific index
  Future<void> updateTimeSlotAtIndex(
      Map<String, dynamic> item, int timeIndex, String newTime) async {
    try {
      final index = _items.indexWhere((i) => i['id'] == item['id']);
      if (index >= 0 && _items[index]['selectedTimes'] != null) {
        List<String> times = List<String>.from(_items[index]['selectedTimes']);
        if (timeIndex < times.length) {
          times[timeIndex] = newTime;
          _items[index]['selectedTimes'] = times;
          notifyListeners();
          await _saveItems();
        }
      }
    } catch (e) {
      debugPrint('Error updating time slot: $e');
      rethrow;
    }
  }

  // Add new time slot
  Future<void> addTimeSlot(Map<String, dynamic> item, String time) async {
    try {
      final index = _items.indexWhere((i) => i['id'] == item['id']);
      if (index >= 0) {
        List<String> times =
            List<String>.from(_items[index]['selectedTimes'] ?? []);
        times.add(time);
        _items[index]['selectedTimes'] = times;
        notifyListeners();
        await _saveItems();
      }
    } catch (e) {
      debugPrint('Error adding time slot: $e');
      rethrow;
    }
  }

  // Load dummy data for testing
  Future<void> addDummyData() async {
    try {
      _items = [
        {
          'type': 'tour_package',
          'id': '1',
          'title': 'Sample Tour Package',
          'image': 'assets/images/singapore_1.jpg',
          'priceHour': 10.0,
          'priceDay': 100.0,
          'selectedTimes': ['28 Feb 2024'],
          'quantity': 1,
          'isSelected': true,
        }
      ];
      notifyListeners();
      await _saveItems();
    } catch (e) {
      debugPrint('Error adding dummy data: $e');
      rethrow;
    }
  }
}
