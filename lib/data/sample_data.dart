import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String desc;
  final double price;

  MenuItem({
    required this.title,
    required this.desc,
    required this.price,
  });
}

class RestaurantLite {
  final String id;
  final String name;
  final String heroImage;
  final String eta;
  final String fee;
  final double rating;
  final int ratingCount;
  final String distance;
  final String category;
  final List<MenuItem> appetizers;

  RestaurantLite({
    required this.id,
    required this.name,
    required this.heroImage,
    required this.eta,
    required this.fee,
    required this.rating,
    required this.ratingCount,
    required this.distance,
    required this.category,
    required this.appetizers,
  });
}

final List<RestaurantLite> restaurants = [
  // American (Pizza + Burger King)
  RestaurantLite(
    id: 'bk',
    name: 'Burger King',
    heroImage: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
    eta: '20–30 min',
    fee: '\$0.99 delivery',
    rating: 4.5,
    ratingCount: 1240,
    distance: '1.2 km',
    category: 'American',
    appetizers: [
      MenuItem(title: 'Whopper', desc: 'Flame-grilled classic', price: 6.99),
      MenuItem(title: 'Fries', desc: 'Crispy golden fries', price: 2.49),
      MenuItem(title: 'Onion Rings', desc: 'Crispy rings', price: 3.99),
    ],
  ),
  RestaurantLite(
    id: 'pizza_palace',
    name: 'Pizza Palace',
    heroImage: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
    eta: '25–35 min',
    fee: '\$0.99 delivery',
    rating: 4.6,
    ratingCount: 540,
    distance: '1.5 km',
    category: 'American',
    appetizers: [
      MenuItem(title: 'Margherita', desc: 'Tomato, mozzarella, basil', price: 10.99),
      MenuItem(title: 'Pepperoni', desc: 'Crispy pepperoni slices', price: 12.49),
      MenuItem(title: 'Garlic Bread', desc: 'Buttery garlic loaf', price: 4.50),
    ],
  ),
  RestaurantLite(
    id: 'napoli_pizzeria',
    name: 'Napoli Pizzeria',
    heroImage: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
    eta: '30–40 min',
    fee: '\$1.49 delivery',
    rating: 4.8,
    ratingCount: 890,
    distance: '2.2 km',
    category: 'American',
    appetizers: [
      MenuItem(title: 'Quattro Formaggi', desc: 'Four cheese blend', price: 14.99),
      MenuItem(title: 'Diavola', desc: 'Spicy salami & chili', price: 13.49),
      MenuItem(title: 'Tiramisu', desc: 'Classic Italian dessert', price: 6.99),
    ],
  ),
  RestaurantLite(
    id: 'slice_heaven',
    name: 'Slice of Heaven',
    heroImage: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
    eta: '20–30 min',
    fee: '\$0.79 delivery',
    rating: 4.4,
    ratingCount: 620,
    distance: '0.8 km',
    category: 'American',
    appetizers: [
      MenuItem(title: 'BBQ Chicken', desc: 'Tangy BBQ sauce & chicken', price: 15.99),
      MenuItem(title: 'Veggie Supreme', desc: 'Loaded vegetable pizza', price: 13.99),
      MenuItem(title: 'Cheesy Breadsticks', desc: 'Mozzarella stuffed', price: 5.99),
    ],
  ),

  // Chinese
  RestaurantLite(
    id: 'dragon_express',
    name: 'Dragon Express',
    heroImage: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=800',
    eta: '30–40 min',
    fee: '\$1.29 delivery',
    rating: 4.2,
    ratingCount: 410,
    distance: '1.8 km',
    category: 'Chinese',
    appetizers: [
      MenuItem(title: 'Spring Rolls', desc: 'Crispy vegetable rolls', price: 5.99),
      MenuItem(title: 'Kung Pao Chicken', desc: 'Spicy chicken with peanuts', price: 12.99),
      MenuItem(title: 'Fried Rice', desc: 'Rice with vegetables & egg', price: 8.99),
    ],
  ),

  // Japanese
  RestaurantLite(
    id: 'sushi_world',
    name: 'Sushi World',
    heroImage: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
    eta: '25–35 min',
    fee: '\$0.99 delivery',
    rating: 4.7,
    ratingCount: 690,
    distance: '2.0 km',
    category: 'Japanese',
    appetizers: [
      MenuItem(title: 'California Roll', desc: 'Crab, avocado, cucumber', price: 9.99),
      MenuItem(title: 'Salmon Nigiri', desc: 'Fresh salmon over rice', price: 12.49),
      MenuItem(title: 'Miso Soup', desc: 'Traditional soybean soup', price: 3.99),
    ],
  ),

  // Dessert
  RestaurantLite(
    id: 'sweet_tooth',
    name: 'Sweet Tooth',
    heroImage: 'https://images.unsplash.com/photo-1604908177520-2d3c60907a85?w=800',
    eta: '15–25 min',
    fee: '\$0.49 delivery',
    rating: 4.9,
    ratingCount: 320,
    distance: '0.5 km',
    category: 'Dessert',
    appetizers: [
      MenuItem(title: 'Chocolate Cake', desc: 'Rich & moist', price: 6.49),
      MenuItem(title: 'Cupcakes', desc: 'Vanilla & chocolate', price: 2.99),
      MenuItem(title: 'Macarons', desc: 'Assorted flavors', price: 4.99),
    ],
  ),
];
