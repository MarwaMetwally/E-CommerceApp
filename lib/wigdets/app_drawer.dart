import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';
import 'package:shopapp/screens/auth_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).getuserId;
    return Drawer(
    
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Freind!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrderScreen.routeName);
            },
          ),
          Divider(),
          userId == 'wfl6FSjXc6Tz14kWvY1YuwPVX7o1'
              ? ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('mange Products'),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, UserProductScreen.routeName);
                  },
                )
              : Container(),
          userId == 'wfl6FSjXc6Tz14kWvY1YuwPVX7o1' ? Divider() : Container(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();

              Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
