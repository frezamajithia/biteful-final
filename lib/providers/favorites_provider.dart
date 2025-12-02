import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};
  Database? _db;

  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String restaurantId) => _favoriteIds.contains(restaurantId);

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            image TEXT,
            rating REAL,
            addedAt TEXT NOT NULL
          )
        ''');
      },
    );

    await _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (_db == null) return;
    final maps = await _db!.query('favorites');
    _favoriteIds.clear();
    for (final map in maps) {
      _favoriteIds.add(map['id'] as String);
    }
    notifyListeners();
  }

  Future<void> toggleFavorite({
    required String id,
    required String name,
    String? image,
    double? rating,
  }) async {
    if (_db == null) await init();

    if (_favoriteIds.contains(id)) {
      // Remove from favorites
      await _db!.delete('favorites', where: 'id = ?', whereArgs: [id]);
      _favoriteIds.remove(id);
    } else {
      // Add to favorites
      await _db!.insert('favorites', {
        'id': id,
        'name': name,
        'image': image ?? '',
        'rating': rating ?? 0.0,
        'addedAt': DateTime.now().toIso8601String(),
      });
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    if (_db == null) await init();
    return await _db!.query('favorites', orderBy: 'addedAt DESC');
  }

  Future<void> clearAllFavorites() async {
    if (_db == null) return;
    await _db!.delete('favorites');
    _favoriteIds.clear();
    notifyListeners();
  }
}
