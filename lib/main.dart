import 'package:flutter/material.dart';
import 'package:shopapp/providers/auth.dart';
import 'screens/products_screen.dart';
import 'screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'providers/orders.dart';
import 'screens/orders_screen.dart';
import 'screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';
import 'package:shopapp/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(null, [], null),
          update: (ctx, auth, prevProducts) => Products(
              auth.token,
              prevProducts == null ? [] : prevProducts.productsItems,
              auth.getuserId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(null, [], null),
          update: (ctx, auth, order) =>
              Orders(auth.token, order.orders, auth.getuserId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
              // fontFamily: 'Smith mouth',
              primaryColor: Colors.grey,
              accentColor: Colors.orange),
          darkTheme: ThemeData(
            appBarTheme: AppBarTheme(color: Colors.black54),
            //fontFamily: 'Smith mouth',
            brightness: Brightness.dark,
            accentColor: Color(0xFFd4cdb3),
          ),
          themeMode: ThemeMode.dark,
          home: auth.isAuth
              ? ProuctsScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authresultSnapshots) =>
                      authresultSnapshots.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.productDetailRoute: (ctx) =>
                ProductDetailScreen(),
            CartScreen.cartRouteName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProduct.routName: (ctx) => EditProduct(),
            AuthScreen.routeName: (ctx) => AuthScreen()
          },
        ),
      ),
    );
  }
}
