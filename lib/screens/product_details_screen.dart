import 'package:flutter/material.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/wigdets/appbartextstyle.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  // ProductDetailScreen(this.title,this.price);
  static const productDetailRoute = '/product_detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).finbyId(productId);
    return Scaffold(
      appBar: AppBar(
        title: AppBarTExtStyle(
          title: loadedProduct.title,
          gradient: LinearGradient(colors: [
            Colors.grey,
            Colors.white,
            Colors.red[500],
            Colors.grey
          ]),
          size: 20,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Hero(
              tag: loadedProduct.id,
              child: Image.network(
                loadedProduct.imagUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text('\$${loadedProduct.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20)),
          SizedBox(height: 10),
          Center(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(loadedProduct.description,
                    textAlign: TextAlign.center)),
          ),
        ],
      ),
    );
  }
}
