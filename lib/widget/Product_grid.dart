import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';

// import '../model/product.dart';
// import '../provider/product.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavourites;
  ProductGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    final ProductsData = Provider.of<ProductsP>(context);
    print(showFavourites);
    final Product = showFavourites ? ProductsData.favItems : ProductsData.items;

    print(Product.length);
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: Product[index],
          // create: (context) => Product[index],
          child: ProductItem(
              // loadedProduct[index].id,
              // loadedProduct[index].imageURL,
              // loadedProduct[index].title,
              ),
        );
      },
      itemCount: Product.length,
    );
  }
}
