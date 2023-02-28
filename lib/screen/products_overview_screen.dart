// displays the grid of products
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../screen/cart_screen.dart';
import '../widget/Product_grid.dart';
import '../widget/badge.dart';
import '../provider/cart.dart';
import '../provider/products_provider.dart';

enum filterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // const ProductsOverviewScreen({Key? key}) : super(key: key);
  var showOnlyFavouritesData = false;
  var isLoading = false;
  @override
  void initState() {
    // Provider.of<ProductsP>(context).fetchAndSetProducts(); //this will not work
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero)
        .then((value) => Provider.of<ProductsP>(context, listen: false)
            .fetchAndSetProducts())
        .then(
      (value) {
        setState(
          () {
            isLoading = false;
          },
        );
      },
    );
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {}
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }
  // this is throwing error of _isInit, check again

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductsP>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (filterOptions selectedValue) {
              // print(selectedValue);
              setState(
                () {
                  if (selectedValue == filterOptions.Favourites) {
                    // productData.ShowFavouritesOnly();
                    // print("In the overview class");
                    showOnlyFavouritesData = true;
                    print(showOnlyFavouritesData);
                  } else {
                    // productData.ShowAll();
                    // show all items
                    showOnlyFavouritesData = false;
                  }
                },
              );
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: filterOptions.Favourites,
                child: Text('Only Favourites'),
              ),
              const PopupMenuItem(
                value: filterOptions.All,
                child: Text('All Items'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cartData, ch) => Badge(
              // key: DateTime.now().toString(),
              value: cartData.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),

          // Consumer<Cart>(
          //   builder: (context, cartData, _) => Badge(
          //     value: cartData.itemCount.toString(),
          //     color: Theme.of(context).colorScheme.secondary,
          //     child: IconButton(
          //       onPressed: () {},
          //       icon: Icon(Icons.shopping_cart),
          //     ),
          //   ),
          // )
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showOnlyFavouritesData),
    );
  }
}
