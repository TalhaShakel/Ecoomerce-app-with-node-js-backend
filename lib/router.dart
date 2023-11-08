// import 'package:amazoneclone/Screens/Auth/AuthScreen.dart';
import 'package:amazone_clone/Screens/Search/Screens/search_Screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/Auth/AuthScreen.dart';
import 'Screens/homeScreen/category_deals_screen.dart';
import 'Screens/homeScreen/home_screen.dart';
import 'features/admin/screens/add_product_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
