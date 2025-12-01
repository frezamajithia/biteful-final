import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/sample_data.dart';

class ApiService {
  static const String baseUrl = 'https://692e04bae5f67cd80a4dab4e.mockapi.io';

  // GET all restaurants
  static Future<List<RestaurantLite>> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/restaurants'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => RestaurantLite.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // GET single restaurant by ID
  static Future<RestaurantLite> getRestaurant(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/restaurants/$id'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return RestaurantLite.fromJson(json);
      } else {
        throw Exception('Failed to load restaurant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // POST a new order
  static Future<Map<String, dynamic>> createOrder({
    required String restaurantName,
    required List<Map<String, dynamic>> items,
    required double total,
    required String status,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'restaurantName': restaurantName,
          'items': items,
          'total': total,
          'status': status,
          'date': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // GET all orders
  static Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
