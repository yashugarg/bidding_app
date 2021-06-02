import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/orderDbService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BidBottom extends StatefulWidget {
  final Product product;
  final ScrollController scrollController;

  const BidBottom(
      {Key? key, required this.product, required this.scrollController})
      : super(key: key);

  @override
  _BidBottomState createState() => _BidBottomState();
}

class _BidBottomState extends State<BidBottom> {
  final textController = TextEditingController();
  bool timer = false;
  Future<void> addBid(AppUser user) async {
    final String bid = textController.text;
    textController.clear();

    await OrderDBServices(uid: user.id).addNewBid(
      pId: widget.product.id,
      value: bid,
    );
  }

  @override
  void initState() {
    DateTime? time = widget.product.biddingTime;
    if (time != null) {
      setState(() {
        timer = DateTime.now().isAfter(time) &&
            DateTime.now().isBefore(time.add(const Duration(days: 1)));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey[300]!)],
          color: Colors.white,
        ),
        // height: 60.0,
        child: timer
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 1,
                        onSubmitted: (value) => addBid(context.read<AppUser>()),
                        keyboardType: TextInputType.number,
                        controller: textController,
                        decoration: const InputDecoration(
                            hintText: "Your Bid",
                            hintStyle: TextStyle(
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      iconSize: 25.0,
                      color: Theme.of(context).accentColor,
                      onPressed: () => addBid(context.read<AppUser>()),
                    ),
                  ],
                ),
              )
            : ListTile(
                leading: Text("Auction Starts on"),
                title: Text(DateFormat.yMMMMd('en_US')
                    .format(widget.product.biddingTime!)),
                subtitle:
                    Text(DateFormat.jm().format(widget.product.biddingTime!)),
              ),
      ),
    );
  }
}
