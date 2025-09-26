import 'package:fardinexpress/features/product/view/widget/product_list_grid_all.dart';
import 'package:fardinexpress/features/product/view/widget/product_search_list_grid_all.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProductByAllCategory extends SearchDelegate {
  final String categoryId;
  final String storeId;
  final String country;
  SearchProductByAllCategory(this.categoryId, this.storeId, this.country);
  // final ExpressController controller =
  //     Get.put(ExpressController(), tag: 'filter');
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
      // Container(
      //   // padding: EdgeInsets.all(0.0),
      //   margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).primaryColor,
      //     shape: BoxShape.circle,
      //   ),
      //   // decoration: BoxDecoration(
      //   //     color: Colors.blue,
      //   //     borderRadius: BorderRadius.circular(standardBorderRadius)),
      //   child: IconButton(
      //       onPressed: () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: ((context) => ScanQrcodePage()))).then((value) {
      //           if (value != null) {
      //             query = value;
      //             // searchBloc!.add(SearchStarted(query: value));
      //             // query = value;
      //             showResults(context);
      //           }
      //         });
      //       },
      //       icon: Icon(
      //         Icons.qr_code_scanner_rounded,
      //         color: Colors.white,
      //       )),
      // )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          // searchBloc!.close();
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_outlined));
    // throw UnimplementedError();
  }

  String? seletedResult;
  @override
  Widget buildResults(BuildContext context) {
    // return Container(width: 10, height: 100, color: Colors.green);
    return ProductSearchListGridAll(
      categoryId: this.categoryId,
      storeId: storeId,
      country: country,
      categoryName: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // searchBloc = SearchBloc()..add(FetchHistory());
    return Container();
  }
}
