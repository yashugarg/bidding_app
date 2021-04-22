import 'package:bidding_app/screens/auth/login.dart';
import 'package:bidding_app/screens/auth/signUp.dart';
import 'package:bidding_app/screens/home/homepage.dart';
import 'package:bidding_app/services/auth.dart';
import 'package:bidding_app/utils/RoutingUtils.dart';
import 'package:bidding_app/widgets/internetCheck.dart';
import 'package:flutter/material.dart';

///     Adding route to router
///  * Step 1: Add your route as a member in Routes class of lib/utils/RoutingUtils.dart
///  * If your route takes an argument mention it above the member as a doc comment
///
///  *Step 2: Add case to this file
///     you can just copy this code and paste it above "Paste code above this comment"
///
///     case Routes.yourRouteName:
///     return MaterialPageRoute(builder: (_) {
///     //run type checks if you want to on arguements
///     return YourWidget();
///     });
///     You can run type checks and return any wigdet you want but don't forget to return some wiget at the end

class Router {
  Router._();

  static Widget wrong = Scaffold(
      body: Center(
    child: Text('Something went wrong'),
  ));

  static MaterialPageRoute routify(Widget screen,{RouteSettings? settings}) => MaterialPageRoute(
    settings:settings ,
      builder: (_) => Scaffold(
            body: screen,
            bottomNavigationBar: CheckInternet(),
          ));

  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      if (!authService.isLoggedIn() &&
          !Routes.unprotectedRouts.contains(settings.name))
        return routify(LoginPage());
      else {
        switch (settings.name) {
          //auth
          // case Routes.forgotPwd:
          //   return routify(Forgotpassword());
          case Routes.login:
            return routify(LoginPage());
          case Routes.signUp:
            return routify(SignupPage());

          //home
          case Routes.homepage:
            return routify(HomePage());

          //user
          // case Routes.userInfo:
          //   return routify(Profile(),settings: settings);
          // case Routes.editProfile:
          //   return routify(EditUserProfile());

          //miscellaneous
          // case Routes.aboutUs:
          //   return routify(AboutUs());
          // case Routes.faqs:
          //   return routify(FAQs());
          // case Routes.contactUs:
          //   if (settings.arguments is String) {
          //     return routify(ContactUs(
          //       initial: settings.arguments as String?,
          //     ));
          //   }
          //   return routify(ContactUs());
          // 

          // Paste new routes above this
          default:
            return routify(
              Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            );
        }
      }
    } catch (e) {
      return routify(wrong);
    }
  }
}
