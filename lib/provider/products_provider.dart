import 'dart:convert';
// this ofers tools for converting data

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/http_exception.dart';

import 'product.dart';

class ProductsP with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageURL:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageURL:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavouritesOnly = false;

  final String authToken;

  ProductsP(this.authToken, this._items);

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((element) => element.isFavourite).toList();
    // }
    return [..._items];
    // the spread operator is used so that the copy of the items list is passed
    // and not the original
    // this increases security of the original data
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://shopapplication-c4ccb-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      // print(json.decode(response.body));

      final List<Product> loadedPrducts = [];

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodID, prodData) {
        loadedPrducts.add(Product(
            id: prodID,
            description: prodData['description'],
            imageURL: prodData['imageURL'],
            price: prodData['price'],
            title: prodData['title'],
            isFavourite: prodData['isFavourite']));
      });
      _items = loadedPrducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    // sending HTTP request

    final url =
        'https://shopapplication-c4ccb-default-rtdb.firebaseio.com/products.json?auth=$authToken';
// this adding into a funtion called response can only be done if await is used
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageURL': product.imageURL,
            'price': product.price,
            'isFavourite': product.isFavourite,
          },
        ),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          description: product.description,
          imageURL: product.imageURL,
          price: product.price,
          title: product.title);
      // _items.add(newProduct);
      _items.insert(
          0, newProduct); // inorder to add at the begining of the list
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
    //   .then(
    // (response) {
    // print(json.decode(response.body));

    // },
    // ).catchError(
    //   (error) {
    //     print(error);
    //     throw error;
    //   },
    // );
    // for body we use json data

    // _items.add(value);
  }

  // void ShowFavouritesOnly() {
  //   print("Changed the value of the flag");
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void ShowAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  // for product detail screen
  Product getbyId(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final ProdIndex = _items.indexWhere((element) => element.id == id);
    if (ProdIndex >= 0) {
      final url =
          'https://shopapplication-c4ccb-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

      await http.patch(
        Uri.parse(url),
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageURL': newProduct.imageURL,
            'price': newProduct.price,
          },
        ),
      );

      _items[ProdIndex] = newProduct;
      notifyListeners();
    } else {
      print("..");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopapplication-c4ccb-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);

    Product? existingproduct = _items[existingProductIndex];

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingproduct);
      throw HttpExpection('Could not delete product');
    } else {
      existingproduct = null;
    }
    _items.removeAt(existingProductIndex);
    // _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
