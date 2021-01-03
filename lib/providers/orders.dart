import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime time;

  OrderItem({this.amount, this.id, this.products, this.time});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userID;
  Orders(this.token, this._orders, this.userID);
  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    final url =
        'https://shop-1bd1e.firebaseio.com/orders/$userID.json?auth=$token';
    final response = await http.get(url);
    final List<OrderItem> loadedorders = [];
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data == null) {
      return;
    } else {
      data.forEach((orderId, orderData) {
        loadedorders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            time: DateTime.parse(orderData['time']),
            products: (orderData['cartitems'] as List<dynamic>)
                .map((e) => CartItem(
                    id: e['id'],
                    price: e['price'],
                    quantity: e['quntity'],
                    title: e['title']))
                .toList()));
      });
      _orders = loadedorders.reversed.toList();
      notifyListeners();
      // print(data);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shop-1bd1e.firebaseio.com/orders/$userID.json?auth=$token';
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'time': DateTime.now().toIso8601String(),
          'cartitems': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            time: DateTime.now()));
    notifyListeners();
  }
}
