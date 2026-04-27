import 'package:balmart/models/item.dart';
import 'package:flutter/material.dart';


class Cart extends ChangeNotifier{
  final String userId;
  final Map<String, Map<String, dynamic>> _items = {};

  Cart({required this.userId});

  // Get All items as a list
  List<Map<String, dynamic>> get cartItems => _items.values.toList();

  // Get Total price across all categories
  double get total =>
      _items.values.fold(0, (sum, item) => sum + (item['item'] as Item).price * (item['cartQty'] as int),
      );

  // Get Number of individual items
  int get totalCount =>
      _items.values.fold(0,(sum,item) => sum + (item['cartQty'] as int),
      );

  // Get Quantity for a specific item
  int getQuantity(String itemId) => _items[itemId]?['cartQty'] ?? 0;

  // Add one of an item
  void increment(Item item) {
    if(_items.containsKey(item.id)) {
      _items[item.id]!['cartQty']++;
    } else {
      _items[item.id] = {'item': item, 'cartQty': 1};
    }
    notifyListeners(); // Tell Flutter to rebuild widgets watching this
  }

  // Remove one of an item
  void decrement(String itemId) {
    if (_items.containsKey(itemId)) {
      if (_items[itemId]!['cartQty'] > 1) {
        _items[itemId]!['cartQty']--;
      } else {
        _items.remove(itemId); // Remove item entirely if count hits 0
      }
      notifyListeners(); // Tells Flutter to rebuild widgets watching this
    }
  }

  // Remove item completely
  void removeItem(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }

  // Clear entire cart after payment
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
