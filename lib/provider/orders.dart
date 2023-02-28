import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
// import 'package:shop/provider/product.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItems> products;
  final DateTime dateTime;

  OrderItem(
      {required this.amount,
      required this.dateTime,
      required this.id,
      required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _order = [];

  final String authToken;

  Orders(this.authToken, this._order);

  List<OrderItem> get orders {
    return [..._order];
  }

  Future<void> fetchAnsSetOrders() async {
    final url =
        'https://shopapplication-c4ccb-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderID, orderData) {
      loadedOrders.add(
        OrderItem(
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          id: orderID,
          products: (orderData['Products'] as List<dynamic>)
              .map(
                (items) => CartItems(
                  id: items['id'],
                  price: items['price'],
                  quantity: items['quantity'],
                  title: items['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _order = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItems> cartProducts, double total) async {
    final url =
        "https://shopapplication-c4ccb-default-rtdb.firebaseio.com/orders.json?auth=$authToken";

    // as http requests takes some time, therefore the timestamp on the server would
    //be different to the timestamp on device hence we use a final timestamp
    final timeStamp = DateTime.now();

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          // this is a special representation used for http requests
          'Products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));

    //  the 0 used in insert means insert in the begining
    _order.insert(
      0,
      OrderItem(
          amount: total,
          dateTime: timeStamp,
          id: json.decode(response.body)['name'],
          products: cartProducts),
    );
    notifyListeners();
  }
}
