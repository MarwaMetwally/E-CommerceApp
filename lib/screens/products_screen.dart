import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:flutter/services.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/wigdets/product_grid.dart';
import 'badge.dart';
import 'package:shopapp/wigdets/appbartextstyle.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import 'package:shopapp/wigdets/app_drawer.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/providers/orders.dart';

enum FilterOptions { favorites, all }

class ProuctsScreen extends StatefulWidget {
  @override
  _ProuctsScreenState createState() => _ProuctsScreenState();
}

class _ProuctsScreenState extends State<ProuctsScreen> {
  var showOnlyFavorites = false;
  var isinit = true;
  bool isloading = false;

  @override
  void initState() {
    // await Provider.of<Products>(context).fetchProducts();
    // Future.delayed(Duration.zero).then((_) => Provider.of<Products>(context).fetchProducts());

    super.initState();
  }

  @override
  didChangeDependencies() {
    if (isinit) {
      setState(() {
        isloading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((_) => setState(() {
            isloading = false;
          }));
    }

    isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //  final cart = Provider.of<Cart>(context, listen: false);

    //  productt = Provider.of<Products>(context);

    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        // title: Center(
        //   child: AppBarTExtStyle('My Shop'),
        // ),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: AppBarTExtStyle(
                title: 'My Shop',
                gradient: LinearGradient(colors: [
                  Colors.grey,
                  Colors.white,
                  Colors.red[500],
                  Colors.grey
                ]),
                size: 25,
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: (selectedValue) {
              print(selectedValue);
              if (selectedValue == FilterOptions.favorites) {
                setState(() {
                  showOnlyFavorites = true;
                });
              } else {
                setState(() {
                  showOnlyFavorites = false;
                });
              }
            },
            icon: Icon(Icons.more_vert_outlined),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Badge(child: child, value: cart.itemCount.toString()),
            ),
            child: IconButton(
                onPressed: () {
                  Provider.of<Orders>(context, listen: false).fetchOrders();
                  // .then((_) =>);
                  Navigator.pushNamed(context, CartScreen.cartRouteName);
                },
                icon: Icon(
                  Icons.shopping_cart,
                  size: 35,
                )),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(7),
              child: ProductsGrid(showOnlyFavorites),
            ),
    );
  }
}
