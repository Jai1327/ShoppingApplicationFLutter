import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  late final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  late bool isFavourite;

  Product({
    required this.id,
    required this.description,
    required this.imageURL,
    required this.price,
    required this.title,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus(String authToken) async {
    final url =
        'https://shopapplication-c4ccb-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final oldStatus = isFavourite;

    isFavourite = !isFavourite;
    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode({
            'isFavourite': isFavourite,
          }));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
      }
    } catch (error) {
      isFavourite = oldStatus;

      // rethrow;
    }

    notifyListeners();
  }
}
