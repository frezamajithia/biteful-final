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
  String? _restaurantName;

  List<CartItem> get items => _items;
  String? get restaurantId => _restaurantId;
  String? get restaurantName => _restaurantName;

  int get totalItems => _items.fold(0, (s, c) => s + c.quantity);
  double get subtotal => _items.fold(0.0, (s, c) => s + c.totalPrice);
  double get taxes => subtotal * 0.13;
  double get total => subtotal + taxes;

  // Returns true if item was added, false if restaurant mismatch
  bool addItem(MenuItem item, String restaurantId, {String? restaurantName, int qty = 1}) {
    if (_restaurantId != null && _restaurantId != restaurantId) {
      return false; // Different restaurant
    }

    _restaurantId = restaurantId;
    if (restaurantName != null) {
      _restaurantName = restaurantName;
    }
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
    _restaurantName = null;
    notifyListeners();
  }

  // Reorder - add items from a previous order
  void reorder({
    required String restaurantName,
    required List<Map<String, dynamic>> items,
  }) {
    clear();
    _restaurantName = restaurantName;
    _restaurantId = 'reorder-${DateTime.now().millisecondsSinceEpoch}';

    for (final item in items) {
      final menuItem = MenuItem(
        title: item['name'] as String,
        desc: 'From previous order',
        price: item['price'] as double,
      );
      _items.add(CartItem(
        item: menuItem,
        restaurantId: _restaurantId!,
        quantity: item['quantity'] as int,
      ));
    }
    notifyListeners();
  }
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}