import 'package:fardinexpress/config/routes/routes.dart';
import 'package:fardinexpress/features/auth/login/view/auth_page.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail_search_url.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // case authPage:
      //   return MaterialPageRoute(builder: (_) => AuthPage());
      case authPage:
        if (args is bool) {
          return MaterialPageRoute(
              builder: (_) => AuthPage(
                    isLogin: args,
                  ));
        }
        return _errorRoute();
      case productDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProductDetailPageWrapper(
            id: args['id'],
            storeId: args['storeId'],
            countryCode: args['countryCode'],
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
