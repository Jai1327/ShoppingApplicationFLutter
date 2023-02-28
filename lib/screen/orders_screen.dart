import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../provider/orders.dart' show Orders;
import '../widget/order_item.dart';

class OrdersScreen extends StatefulWidget {
  // const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = '/orderScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _futureOrders;

  Future _obtainOrders() {
    return Provider.of<Orders>(context, listen: false).fetchAnsSetOrders();
  }

  @override
  void initState() {
    _futureOrders = _obtainOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _futureOrders,
          builder: (ctx, dataSnapShot) {
            // print(dataSnapShot.connectionState);
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapShot.error != null) {
                return Center(
                  child: Text("Error Occured"),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                          itemBuilder: (context, i) =>
                              OrderItem(orderData.orders[i]),
                          itemCount: orderData.orders.length,
                        ));
              }
            }
          },
        ));
  }
}
