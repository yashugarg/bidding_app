import 'package:bidding_app/utils/size_config.dart';
import 'package:flutter/material.dart';
// import 'package:bidding_app/widgets/product_card.dart';
// import 'package:bidding_app/models/product.dart';

class PopularProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular Products",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: null,
                child: Text(
                  "See More",
                  style: TextStyle(color: Color(0xFFBBBBBB)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // ...List.generate(
              //   demoProducts.length,
              //   (index) {
              //     if (demoProducts[index].isPopular)
              //       return ProductCard(product: demoProducts[index]);

              //     return SizedBox
              //         .shrink(); // here by default width and height is 0
              //   },
              // ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }
}
