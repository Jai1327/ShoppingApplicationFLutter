import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // const ProductDetailScreen({Key? key}) : super(key: key);
  // final String title;
  // ProductDetailScreen(this.title);

  static const routeName = '/ProductDetailScreen';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)?.settings.arguments as String;
    // this is used to read the passed data using the pushed names
    // from the product Item
    final ProductsData =
        Provider.of<ProductsP>(context, listen: false).getbyId(productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(ProductsData.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(ProductsData.imageURL, fit: BoxFit.cover),
            ),
            const SizedBox(
              height: 10,
            ),
            // this text holds the price of the product
            Text(
              "Rs.${ProductsData.price}",
              style: Theme.of(context).primaryTextTheme.titleMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                ProductsData.description,
                textAlign: TextAlign.center,
                softWrap: true,
                // this means it will go in a new line if it overflows
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}
