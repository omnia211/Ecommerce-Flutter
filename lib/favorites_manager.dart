import 'package:flutter/material.dart';

class FavoritesManager {
  static final List<Map<String, dynamic>> _favorites = [];

  static List<Map<String, dynamic>> get favorites => _favorites;

  static bool isFavorite(int id) {
    return _favorites.any((p) => p['id'] == id);
  }

  static void toggleFavorite(Map<String, dynamic> product) {
    final existingIndex = _favorites.indexWhere((p) => p['id'] == product['id']);
    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
    } else {
      _favorites.add(product);
    }
  }
}
