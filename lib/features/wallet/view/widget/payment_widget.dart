import 'package:fardinexpress/shared/bloc/item_indexing.dart/item_indexing_bloc.dart';
import 'package:fardinexpress/shared/bloc/item_indexing.dart/item_indexing_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Map> paymentMethodList = [
  {
    "name": "ABA",
    "image": "assets/img/payment/aba-logo.png",
    "description": "010 601 168 | Sim Sophea"
  },
  {
    "name": "Aceleda",
    "image": "assets/img/payment/aceleda.png",
    "description": "010 601 168 | Sim Sophea"
  },
  // {
  //   "name": "(Phone Number)",
  //   "image": "assets/images/payment_service/phone_transfer.jpg",
  //   "description": "Tel: 078 622 544"
  // }
];
Future<void> paymentMethodDialog(BuildContext c) async {
  return showDialog(
      context: c,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            content: Container(
              padding: EdgeInsets.all(15),
              //height: 500,
              width: MediaQuery.of(context).size.width - 30,
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 5),
                  Text(
                    "Choose Transfer Method",
                    // AppLocalizations.of(context)!
                    //     .translate("chooseTransferMethod")!,
                    textScaleFactor: 1,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Divider(
                      // height: 8,
                      ),
                  ...paymentMethodList
                      .map(
                        (data) => Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<ItemIndexingBloc>(c).add(Taped(
                                    index: paymentMethodList.indexOf(data)));
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                // color: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                //color: Colors.red,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                      height: 50,
                                      // width: 15,
                                      // height: 15,
                                      image: AssetImage(data["image"]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data["name"],
                                            textScaleFactor: 0.9,
                                            maxLines: 2,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            data["description"],
                                            textScaleFactor: 0.9,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 8,
                            )
                          ],
                        ),
                      )
                      .toList()
                ]),
              ),
            ));
      });
}
