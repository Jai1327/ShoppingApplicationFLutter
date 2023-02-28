import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';

import './provider/orders.dart';
import './screen/cart_screen.dart';
import './provider/cart.dart';
import './screen/product_detail_screen.dart';
import './screen/products_overview_screen.dart';
import './provider/products_provider.dart';
import './screen/cart_screen.dart';
import './screen/user_products_screen.dart';
import './screen/orders_screen.dart';
import './screen/edit_product_screen.dart';
import './screen/auth_screen.dart';
import './provider/auth.dart';
import './model/http_exception.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // used to add multiple providers
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => ProductsP(),
        // ),
        ChangeNotifierProxyProvider<Auth, ProductsP>(
          update: (ctx, auth, previousProducts) => ProductsP(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
          create: (_) => ProductsP('', []),
          // yea create me doubt hai
        ),
        // ChangeNotifierProvider.value(value: ProductsP(),),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', []),
          update: (ctx, auth, previousOrders) => Orders(
              auth.token, previousOrders == null ? [] : previousOrders.orders),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => Orders(),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primaryTextTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            fontFamily: 'Lato',
            // primarySwatch: Colors.purple,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
            ).copyWith(
              secondary: Colors.red,
            ),
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            // '/': (context) => ProductsOverviewScreen(),
            // AuthScreen.routeName(context)=> AuthScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routename: (context) => UserProductsScreen(),
            EditProductScreen.routename: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MyShop'),
//       ),
//       body: Center(
//         child: Text('Let\'s build a shop!'),
//       ),
//     );
//   }
// }
