import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'biteful.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurantName TEXT NOT NULL,
        total REAL NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER NOT NULL,
        itemName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unitPrice REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL
      )
    ''');
    
    await db.insert('users', {
      'id': 1, 
      'name': 'Guest User', 
      'email': 'guest@biteful.app'
    });
  }

  Future<Map<String, dynamic>?> fetchUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users', where: 'id = 1');
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<void> updateUser(String name, String email) async {
    final db = await database;
    final count = await db.update(
      'users',
      {'name': name, 'email': email},
      where: 'id = 1',
    );
    if (count == 0) {
      await db.insert('users', {
        'id': 1,
        'name': name,
        'email': email
      });
    }
  }

  // Insert a single order and return its ID
  Future<int> insertOrder(Order order) async {
    final db = await database;
    return await db.insert('orders', order.toMap());
  }

  // Insert a single order item
  Future<void> insertOrderItem(int orderId, OrderItem item) async {
    final db = await database;
    final itemWithOrderId = OrderItem(
      id: item.id,
      orderId: orderId,
      itemName: item.itemName,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
    );
    await db.insert('order_items', itemWithOrderId.toMap());
  }

  // Insert order items in bulk
  Future<void> insertOrderItems(List<OrderItem> items) async {
    final db = await database;
    final batch = db.batch();
    for (final item in items) {
      batch.insert('order_items', item.toMap());
    }
    await batch.commit(noResult: true);
  }

  // Fetch all orders
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final db = await database;
    return await db.query('orders', orderBy: 'createdAt DESC');
  }

  // Fetch all orders as Order models
  Future<List<Order>> fetchOrdersAsModels() async {
    final db = await database;
    final maps = await db.query('orders', orderBy: 'createdAt DESC');
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  // Fetch order items for a specific order
  Future<List<Map<String, dynamic>>> fetchOrderItems(int orderId) async {
    final db = await database;
    return await db.query(
      'order_items',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  // Clear all orders and order items
  Future<void> clearOrders() async {
    final db = await database;
    await db.delete('order_items');
    await db.delete('orders');
  }

  // Method to completely reset the database
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'biteful.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}