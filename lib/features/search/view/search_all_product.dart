import 'package:fardinexpress/features/product/view/widget/product_detail_search_url.dart';
import 'package:fardinexpress/features/product/view/widget/product_search_list_grid_all.dart';
import 'package:fardinexpress/features/search/view/widget/product_list_by_search.dart';
import 'package:fardinexpress/features/shop/controller/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchAllProduct extends SearchDelegate {
  final String countryCode;
  final String store;
  SearchAllProduct({required this.countryCode, required this.store});
  bool isUrl(String input) {
    final urlPattern =
        RegExp(r'^https?://[^\s/$.?#].[^\s]*$', caseSensitive: false);
    return urlPattern.hasMatch(input);
  }

  @override
  ThemeData appBarTheme(BuildContext? context) {
    assert(context != null);
    final ThemeData? theme = Theme.of(context!);
    assert(theme != null);
    return theme!.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.black),
      // primaryColorBrightness: Brightness.dark,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];

    // throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_outlined));
    // throw UnimplementedError();
  }

  bool isWebUrl(String value) {
    final urlPattern = r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-./?%&=]*)?$';
    final result = RegExp(urlPattern, caseSensitive: false).hasMatch(value);
    return result;
  }

  String? seletedResult;
  @override
  Widget buildResults(BuildContext context) {
    if (Get.isRegistered<StoreController>(
        tag: 'searchProductByAllCategoryCtr')) {
      Get.find<StoreController>(tag: 'searchProductByAllCategoryCtr')
          .isRefresh
          .value = true;
    }
    if (isWebUrl(query)) {
      return ProductDetailSearchUrl(webUrl: query);
    } else {
      return ProductSearchListGridAll(
        categoryId: query,
        country: countryCode,
        storeId: store,
        categoryName: '',
      );
    }

    // return ProductDetailSearchUrl(webUrl: query);
    // return ProductListBySearch(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
