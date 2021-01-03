import 'package:flutter/material.dart';
import 'package:shopapp/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final authdata = Provider.of<Auth>(context);

    // final cart = Provider.of<Cart>(context, listen: false);
    // print('rebuilddd');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: GridTile(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                    ProductDetailScreen.productDetailRoute,
                    arguments: product.id);
              },
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(
                    product.imagUrl,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red[900],
                  ),
                  onPressed: () {
                    product.toggleFavorites(authdata.token, authdata.getuserId);
                  }),
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            trailing: Consumer<Cart>(
              builder: (context, cart, child) => IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    cart.addItem(product.id, product.title, product.price);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Item added to cart'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          }),
                    ));
                  }),
            ),
          )),
    );
  }
}
