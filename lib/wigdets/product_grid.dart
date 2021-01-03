import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/wigdets/productitem.dart';
import 'package:shopapp/providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showfav;
  ProductsGrid(this.showfav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showfav ? productsData.favItems : productsData.productsItems;
    return GridView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        //create: (ctx) => productsData.productsItems[index],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.15,
          crossAxisSpacing: 9,
          mainAxisSpacing: 9),
    );
  }
}
