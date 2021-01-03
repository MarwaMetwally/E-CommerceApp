import 'package:flutter/material.dart';
import 'package:shopapp/providers/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopapp/models/Exception.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imagUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //       id: 'p2',
    //       title: 'Trousers',
    //       description: 'A nice pair of trousers.',
    //       price: 59.99,
    //       imagUrl:
    //           'https://www.dunhill.com/product_image/12398425gx/f/w750_be4e4e4.jpg'),
    //   Product(
    //       id: 'p3',
    //       title: 'Dress',
    //       description: 'A cute dress.',
    //       price: 59.99,
    //       imagUrl:
    //           'https://www.rockmywedding.co.uk//wp-content/uploads/sites/1/nggallery/toddler-flower-girl-dresses//Monsoon-May-Broderie-flower-girl-Dress-blush.jpg'),
    //   Product(
    //       id: 'p4',
    //       title: ' Suit',
    //       description: 'Hollywood Suit Modern Fit Solid Black suit.',
    //       price: 59.99,
    //       imagUrl:
    //           'https://www.hollywoodsuits.com/media/catalog/product/cache/10f519365b01716ddb90abc57de5a837/h/3/h320-0s2_01-black_a.jpg'),
  ];
  //var _showFavoriteOnly = false;
  final String authToken;
  final String userId;
  Products(this.authToken, this._products, this.userId);
  List<Product> get productsItems {
    // if (_showFavoriteOnly == true) {
    //   return _products.where((element) => element.isFavorite).toList();
    // }
    return _products;
  }

  List<Product> get favItems {
    return _products.where((element) => element.isFavorite).toList();
  }

  Product finbyId(String id) {
    return productsItems.firstWhere((pro) => pro.id == id);
  }

  Future<void> fetchProducts() async {
    var url = 'https://shop-1bd1e.firebaseio.com/products.json?auth=$authToken';
    try {
      final responce = await http.get(url);
      final data = json.decode(responce.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }

      url =
          'https://shop-1bd1e.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      List<Product> loadedProducts = [];
      data.forEach((prodID, data) {
        loadedProducts.add(Product(
            id: prodID,
            isFavorite: favData == null ? false : favData[prodID] ?? false,
            title: data['title'],
            price: data['price'],
            imagUrl: data['imageurl'],
            description: data['description']));
      });
      // for (int i = 0; i < loadedProducts.length; i++) {
      //   print(loadedProducts[i].title);
      // }
      _products = loadedProducts;
      // for (int i = 0; i < _products.length; i++) {
      //   print(_products[i].isFavorite);
      // }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product prod) async {
    final url =
        'https://shop-1bd1e.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': prod.title,
            'price': prod.price,
            'description': prod.description,
            'imageurl': prod.imagUrl,
          }));
      final newproduct = Product(
          id: json.decode(response.body)['name'],
          title: prod.title,
          description: prod.description,
          imagUrl: prod.imagUrl,
          price: prod.price);
      productsItems.add(newproduct);
      notifyListeners();
    } catch (e) {
      // print(e);
      throw e;
    }

    // .then((response) {
    // print(json.decode(response.body));

    //   }).catchError((e) {
    //   print(e);
    //   throw e;
    //  });
  }

  Future<void> updateProduct(String id, Product prod) async {
    final url =
        'https://shop-1bd1e.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(url,
        body: json.encode({
          'title': prod.title,
          'price': prod.price,
          'description': prod.description,
          'imageurl': prod.imagUrl,
        }));

    final productIndex = productsItems.indexWhere(
      (element) => (element.id == id),
    );
    productsItems[productIndex] = prod;
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://shop-1bd1e.firebaseio.com/products/$id.json?auth=$authToken';
    final productIndex = _products.indexWhere(
      (element) => (element.id == id),
    );
    var currentproduct = _products[productIndex];
    _products.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(productIndex, currentproduct);
      notifyListeners();
      throw HttpException('could not delete product');
    } else {
      currentproduct = null;
    }
  }
}
