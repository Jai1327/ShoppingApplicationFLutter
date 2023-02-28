import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/edit_product_screen.dart';
import '../provider/products_provider.dart';

class UserProductItem extends StatelessWidget {
  // const UserProductItem({Key? key}) : super(key: key);
  final String title;
  final String id;
  final String imageURL;

  UserProductItem(this.id, this.imageURL, this.title);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      // image provider yields a network image
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routename,
                  arguments: id,
                );
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductsP>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text('Deleting Failed'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
