import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String id;
  UserProductItem({this.imgUrl, this.title, this.id});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imgUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, EditProduct.routName,
                      arguments: id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[900],
                ),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(id);
                  } catch (e) {
                    scaffold.showSnackBar(SnackBar(
                      content: Text('Deleting Failed !'),
                    ));
                  }
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Product is removed'),
                    duration: Duration(seconds: 2),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
