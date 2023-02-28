// import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop/provider/product.dart';
// import 'package:provider/provider.dart';

class CartItems {
  // this defines how a cart item should look like
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItems(
      {required this.id,
      // this id is different than product id
      required this.price,
      required this.quantity,
      required this.title});
}

class Cart with ChangeNotifier {
  late Map<String, CartItems> _items = {};
  // this maps the prodct id to the cart item

  Map<String, CartItems> get items {
    return {..._items};
    // the spread operator is used to send a new map and keep the original intact
  }

  int get itemCount {
    //returning the distinct products
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
      (key, value) {
        total += value.quantity * value.price;
      },
    );

    return total;
  }

  void removeItem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void addItem(String productid, double price, String title) {
    // used to add items to the cart
    if (_items.containsKey(productid)) {
      // change the quantity
      _items.update(
        productid,
        (existingCartItem) => CartItems(
          // value is the existing element of cartItem
          id: existingCartItem.id,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          title: existingCartItem.title,
        ),
      );
    } else {
      _items.putIfAbsent(
        productid,
        () => CartItems(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
        ),
      );
    }
    notifyListeners();
  }

  // this method will be used when an order is palced
  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }
    if (_items[productID]!.quantity > 1) {
      _items.update(
        productID,
        (value) => CartItems(
            id: value.id,
            price: value.price,
            quantity: value.quantity - 1,
            title: value.title),
      );
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }
}
