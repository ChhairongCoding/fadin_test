import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:flutter/material.dart';

Widget appBar({required BuildContext context}) {
  double statusBarHeight = MediaQuery.of(context).padding.top;
  // final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  return Container(
    // color: Theme.of(context).primaryColor,
    margin: EdgeInsets.all(0),
    width: MediaQuery.of(context).size.width - 30,
    height: double.infinity,
    // color: Theme.of(context).primaryColor,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Container(
        //   margin: EdgeInsets.only(top: statusBarHeight, right: 0, left: 0),
        //   child: AspectRatio(
        //     aspectRatio: 1,
        //     child: FlatButton(
        //       color: Colors.transparent,
        //       padding: EdgeInsets.only(top: 13, bottom: 13, right: 0, left: 0),
        //       child: Image(
        //         image: AssetImage(
        //             BlocProvider.of<LanguageBloc>(context).state ==
        //                     LanguageState(Locale('en', 'US'))
        //                 ? "assets/icons/en_us.png"
        //                 : "assets/icons/km_kh.png"),
        //       ),
        //       onPressed: () {
        //         languageModal(context);
        //       },
        //     ),
        //   ),
        // ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // showSearch(context: context, delegate: SearchPage());
            },
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius:
                      BorderRadius.all(Radius.circular(searchBarBorderRadius))),
              margin: EdgeInsets.only(
                  left: 5, top: statusBarHeight + 12, right: 10, bottom: 12),
              child: Card(
                margin: EdgeInsets.only(left: 0),
                color: Colors.grey[300],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(searchBarBorderRadius),
                ),
                //margin: EdgeInsets.all(0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Search",
                      // AppLocalizations.of(context)!.translate("search")!,
                      style: TextStyle(color: Colors.grey[600]),
                      textScaleFactor: 1,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        // Container(
        //     margin: EdgeInsets.only(top: statusBarHeight),
        //     child: IconButton(
        //         icon: Icon(Icons.chat_outlined),
        //         onPressed: () async {
        //           await launch("https://t.me/pheakdeyChea");
        //         }))
        Container(
            margin: EdgeInsets.only(top: statusBarHeight, right: 0),
            child: AspectRatio(
              aspectRatio: 1,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.notifications, color: Colors.black),
                    onPressed: () {}),
              ),
            )),
      ],
    ),
  );
}
