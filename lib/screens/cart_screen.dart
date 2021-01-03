import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart' show Cart;
import 'package:shopapp/wigdets/cartitem.dart' as cartitem;
import 'package:shopapp/wigdets/appbartextstyle.dart';
import 'package:shopapp/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const cartRouteName = 'CartScreen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart '),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFd4cdb3).withOpacity(0.4),
                    Colors.white
                    //Colors.white,
                    // Colors.red[500].withOpacity(0.6),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(width: 1, color: Colors.black)),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: AppBarTExtStyle(
                          title: 'Total',
                          size: 22,
                          gradient: LinearGradient(colors: [
                            Colors.black87,
                            Colors.black54,
                            Colors.red[900]
                          ]),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Spacer(),
                    Chip(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                      label: Text(
                        ' \$${cart.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 17),
                      ),
                      backgroundColor: Colors.black54,
                    ),
                    // Color(0xff2c362c)
                    OrderBUtton(cart: cart),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, i) => cartitem.CartItem(
                  id: cart.items.values.toList()[i].id,
                  productid: cart.items.keys.toList()[i],
                  price: cart.items.values.toList()[i].price,
                  quntity: cart.items.values.toList()[i].quantity,
                  title: cart.items.values.toList()[i].title),
            ),
          )
        ],
      ),
    );
  }
}

class OrderBUtton extends StatefulWidget {
  const OrderBUtton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderBUttonState createState() => _OrderBUttonState();
}

class _OrderBUttonState extends State<OrderBUtton> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isloading
          ? CircularProgressIndicator()
          : AppBarTExtStyle(
              title: 'Order Now',
              size: 19,
              gradient: (widget.cart.itemCount <= 0 || isloading)
                  ? LinearGradient(colors: [Colors.white, Colors.white])
                  : LinearGradient(colors: [
                      Colors.black87,
                      Colors.black54,
                      Colors.red[900]
                    ])),
      onPressed: (widget.cart.itemCount <= 0 || isloading)
          ? null
          : () async {
              setState(() {
                isloading = true;
              });
              print('pressed');
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalPrice);
              setState(() {
                isloading = false;
              });
              widget.cart.clear();
            },
    );
  }
}
