import 'package:flutter/material.dart';

import '../models/product.dart';
import '../views/cart/cart_screen.dart';
import '../views/product_detail/product_detail_screen.dart';
import '../views/product_list/product_list_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String cart = '/cart';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const ProductListScreen());
      case detail:
        final Product product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => const ProductDetailScreen(),
          settings: RouteSettings(arguments: product),
        );
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
