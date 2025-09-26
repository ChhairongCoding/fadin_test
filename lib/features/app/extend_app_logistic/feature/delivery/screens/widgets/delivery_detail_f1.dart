import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class DeliveryDetailF1 extends StatelessWidget {
  final Delivery deliver;
  DeliveryDetailF1({required this.deliver});
  @override
  Widget build(BuildContext context) {
    String _receiver = "";
    String _sender = "";
    if (deliver.receiver != null) {
      _receiver = Helper.connectString([
        deliver.receiver!.name,
        deliver.receiver!.phone,
        deliver.receiver!.address
      ]);
    }
    if (deliver.sender != null) {
      _sender = Helper.connectString([
        deliver.sender!.name,
        deliver.sender!.phone,
        deliver.sender!.address
      ]);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(standardBorderRadius)),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [
                    DotIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: 5,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).primaryColor,
                                Colors.orange[700]!
                              ],
                            ),
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "sender",
                      textScaleFactor: 1,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _sender,
                      // style: Theme.of(context)
                      //     .primaryTextTheme
                      //     .bodyText1!
                      //     .copyWith(height: 1.5),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Text("dgdgdsgdgg dgdgsdgdddddddddddddddddd ddddddddddddd "),
                  ],
                ))
              ],
            ),
          ),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DotIndicator(
                color: Colors.orange[700],
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "receiver",
                    textScaleFactor: 1,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium!
                        .copyWith(color: Colors.orange[700]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _receiver,
                    // style: Theme.of(context)
                    //     .primaryTextTheme
                    //     .bodyText1!
                    //     .copyWith(height: 1.5),
                  ),
                  // deliver.status.toLowerCase() == "completed"
                  //     ? Center()
                  //     : Container(
                  //         margin: EdgeInsets.only(top: 5),
                  //         child: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               padding: EdgeInsets.all(10),
                  //               // shape: RoundedRectangleBorder(
                  //               //     borderRadius: BorderRadius.circular(
                  //               //         standardBorderRadius)),
                  //               primary: Theme.of(context).primaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "បញ្ជាដឹកមកដល់ទីកន្លែង",
                  //               style: TextStyle(color: Colors.white),
                  //             )),
                  //       )
                  // Text("dgdgdsgdgg dgdgsdgdddddddddddddddddd ddddddddddddd "),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
