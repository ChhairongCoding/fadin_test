import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/screens/widgets/scan_qrcode_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/screens/widgets/tracking_delivery_item.dart';
import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackingDeliveryOrder extends SearchDelegate {
  final ExpressController controller =
      Get.put(ExpressController(), tag: 'filter');
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
      // IconButton(
      //   icon: Icon(Icons.close),
      //   onPressed: () {
      //     query = "";
      //   },
      // )
      Container(
        // padding: EdgeInsets.all(0.0),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        // decoration: BoxDecoration(
        //     color: Colors.blue,
        //     borderRadius: BorderRadius.circular(standardBorderRadius)),
        child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ScanQrcodePage()))).then((value) {
                if (value != null) {
                  query = value;
                  // searchBloc!.add(SearchStarted(query: value));
                  // query = value;
                  showResults(context);
                }
              });
            },
            icon: Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
            )),
      )
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
    return TrackingOrderResult(
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // searchBloc = SearchBloc()..add(FetchHistory());
    return Container(
        // width: double.infinity,
        // height: double.infinity,
        // color: Colors.white,
        // child: BlocBuilder(
        //     bloc: searchBloc,
        //     builder: (c, state) {
        //       if (searchBloc!.historyList.length == 0) {
        //         if (state is Searched) {
        //           return Container();
        //         }
        //         return Center(child: CircularProgressIndicator());
        //       } else {
        //         return SingleChildScrollView(
        //           child: Container(
        //             margin: EdgeInsets.symmetric(horizontal: 15),
        //             child: Column(children: [
        //               ...searchBloc!.historyList
        //                   .map((history) => Column(
        //                         children: [_tile(context, history), Divider()],
        //                       ))
        //                   .toList(),
        //               Container(
        //                 width: double.infinity,
        //                 // height: double.infinity,
        //                 child: TextButton(
        //                     onPressed: () {
        //                       searchBloc!.add(ClearAllHistory());
        //                     },
        //                     style: TextButton.styleFrom(
        //                       padding: EdgeInsets.all(15),
        //                       backgroundColor: Colors.white,
        //                     ),
        //                     child: Text(
        //                       "Clear All History",
        //                       // AppLocalizations.of(context)!
        //                       //     .translate("clearAllHistory")!,
        //                       style: TextStyle(color: Colors.black),
        //                     )),
        //               ),
        //             ]),
        //           ),
        //         );
        //       }
        //     }),
        );
  }
}
