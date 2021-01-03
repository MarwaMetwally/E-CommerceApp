import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/wigdets/userProductItem.dart';
import 'package:shopapp/wigdets/app_drawer.dart';
import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userProductsScreen';

  // Future<void> _refreshProducts(BuildContext context) async {
  //   print(" \'d5lt gwa' ");
  //   await Provider.of<Products>(context).fetchProducts();s

  // }

  @override
  Widget build(BuildContext context) {
    final productss = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, EditProduct.routName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Products>(context, listen: false).fetchProducts();
        },
        child: ListView.builder(
          itemCount: productss.productsItems.length,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserProductItem(
                title: productss.productsItems[i].title,
                imgUrl: productss.productsItems[i].imagUrl,
                id: productss.productsItems[i].id,
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}
