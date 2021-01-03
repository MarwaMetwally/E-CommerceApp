import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quntity;
  final String title;
  final String productid;
  CartItem({this.productid, this.id, this.price, this.quntity, this.title});
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Are Yoy Sure ?'),
                    content:
                        Text('Do you want to remove the item from the cart?'),
                    elevation: 10,
                    backgroundColor: Colors.grey,
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text('No')),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text('Yes'))
                    ],
                  ));
        },
        onDismissed: (direction) {
          cart.removeItem(productid);
        },
        child: Card(
          elevation: 10,
          shadowColor: Colors.grey,
          child: ListTile(
            leading: CircleAvatar(
              child: CircleAvatar(
                backgroundColor: Colors.red[900],
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      '\$$price',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            title: Text('$title'),
            subtitle: Text('Total:\$${(price * quntity)}'),
            trailing: Text('$quntity X'),
          ),
        ),
      ),
    );
  }
}
