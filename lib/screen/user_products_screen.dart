import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// show the list of all the products of the user
// can be done better when authentication is added

import '../provider/products_provider.dart';
import '../widget/user_product_item.dart';
import '../widget/app_drawer.dart';
import '../screen/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  // const UserProductsScreen({Key? key}) : super(key: key);

  static const routename = '/UserProduct';

  Future<void> _RefreshProducts(BuildContext context) async {
    Provider.of<ProductsP>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductsData = Provider.of<ProductsP>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routename);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _RefreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) {
              return Column(
                children: [
                  UserProductItem(
                    ProductsData.items[i].id,
                    ProductsData.items[i].imageURL,
                    ProductsData.items[i].title,
                  ),
                  Divider()
                ],
              );
            },
            itemCount: ProductsData.items.length,
          ),
        ),
      ),
    );
  }
}
