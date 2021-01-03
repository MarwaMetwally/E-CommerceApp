import 'package:flutter/material.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderrItem extends StatefulWidget {
  final OrderItem order;
  OrderrItem(this.order);

  @override
  _OrderrItemState createState() => _OrderrItemState();
}

class _OrderrItemState extends State<OrderrItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.grey,
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.time)),
            trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Container(
                height: MediaQuery.of(context).size.height / 7,
                child: ListView(
                    children: widget.order.products
                        .map((e) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text('${e.quantity} x \$${e.price}')
                              ],
                            ))
                        .toList()),
              ),
            )
        ],
      ),
    );
  }
}
