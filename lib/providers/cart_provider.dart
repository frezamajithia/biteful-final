import 'package:flutter/material.dart';
import '../data/sample_data.dart';

class CartItem {
  final MenuItem item;
  final String restaurantId;
  int quantity;
  CartItem({required this.item, required this.restaurantId, this.quantity = 1});
  double get totalPrice => item.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _restaurantId;

  List<CartItem> get items => _items;
  String? get restaurantId => _restaurantId;

  String? get restaurantName {
    if (_restaurantId == null) return null;
    try {
      final r = restaurants.firstWhere((e) => e.id == _restaurantId);
      return r.name;
    } catch (_) {
      return null;
    }
  }

  int get totalItems => _items.fold(0, (s, c) => s + c.quantity);
  double get subtotal => _items.fold(0.0, (s, c) => s + c.totalPrice);
  double get taxes => subtotal * 0.13;
  double get total => subtotal + taxes;

  // Returns true if item was added, false if restaurant mismatch
  bool addItem(MenuItem item, String restaurantId, {int qty = 1}) {
    if (_restaurantId != null && _restaurantId != restaurantId) {
      return false; // Different restaurant
    }

    _restaurantId = restaurantId;
    final existing = _items.where((c) => c.item.title == item.title).firstOrNull;
    if (existing != null) {
      existing.quantity += qty;
    } else {
      _items.add(CartItem(item: item, restaurantId: restaurantId, quantity: qty));
    }
    notifyListeners();
    return true;
  }

  void removeOne(MenuItem item) {
    final existing = _items.where((c) => c.item.title == item.title).firstOrNull;
    if (existing != null) {
      existing.quantity--;
      if (existing.quantity <= 0) {
        _items.remove(existing);
      }
      if (_items.isEmpty) _restaurantId = null;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _restaurantId = null;
    notifyListeners();
  }
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}