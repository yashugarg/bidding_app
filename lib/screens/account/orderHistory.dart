import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/userDbService.dart';
import 'package:bidding_app/widgets/commonUI/AppStreamBuilder.dart';
import 'package:bidding_app/widgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      // body: Container(
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: StrmBldr<List<Order>>(
      //           stream: UserDBServices().fetchMyOrders(),
      //           noDataWidget: Center(
      //               child: Text("You haven't ordered anything yet")),
      //           builder: (context, value) {
      //             return ListView.builder(
      //               children:
      //                   value!.map((e) => OrederCard(order: e)).toList(),
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
