import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'components/categories.dart';
import 'components/discount_banner.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * 0.6,
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        onChanged: (value) => print(value),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(20),
                                vertical: getProportionateScreenWidth(9)),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "Search product",
                            prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                    IconButton(icon: Icon(Icons.shopping_cart_rounded), onPressed: null),
                    IconButton(icon: Icon(Icons.notifications), onPressed: null),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenWidth(10)),
              DiscountBanner(),
              Categories(),
              SpecialOffers(),
              SizedBox(height: getProportionateScreenWidth(30)),
              PopularProducts(),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
