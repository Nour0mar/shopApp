import 'package:flutter/material.dart';
import 'package:online_shop/provider/auth.dart';
import 'package:online_shop/provider/cart.dart';
import 'package:online_shop/provider/orders.dart';
import 'package:online_shop/screens/auth_screen.dart';
import 'package:online_shop/screens/cart_screen.dart';
import 'package:online_shop/screens/edit_product_screen.dart';
import 'package:online_shop/screens/product_details_screen.dart';
import 'package:online_shop/screens/products_overview_screen.dart';
import 'package:online_shop/screens/splash_screen.dart';
import 'package:online_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'provider/products.dart';
import 'package:online_shop/screens/order_screen.dart';
import 'helpers/custom_route.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Shop',
            theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                 TargetPlatform.android:CustomPageTransitionBuilder(),
                  TargetPlatform.iOS:CustomPageTransitionBuilder(),
                }
              ),
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, autoResultSnapshot) =>
                        autoResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
              //ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            }),
      ),
    );
  }
}
