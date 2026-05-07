import 'package:flutter/material.dart';
import 'package:projeto_integrado/data/models/product_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<ProductModel> _favorites = [];

  List<ProductModel> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(ProductModel product) {
    return _favorites.any((item) => item.pdfUrl == product.pdfUrl);
  }

  void toggleFavorite(ProductModel product) {
    if (isFavorite(product)) {
      _favorites.removeWhere((item) => item.pdfUrl == product.pdfUrl);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  void removeFavorite(ProductModel product) {
    _favorites.removeWhere((item) => item.pdfUrl == product.pdfUrl);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
