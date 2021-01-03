import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imagUrl;
  bool isFavorite;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imagUrl,
      @required this.price,
      this.isFavorite = false});
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  void toggleFavorites(String token, String userId) async {
    final oldfav = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();
    final url =
        'https://shop-1bd1e.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavValue(oldfav);
      }
    } catch (e) {
      _setFavValue(oldfav);
    }
  }
}
