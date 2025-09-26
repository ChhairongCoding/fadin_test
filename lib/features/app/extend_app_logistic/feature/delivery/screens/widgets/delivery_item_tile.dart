import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/helper/helper.dart';
import 'package:flutter/material.dart';
import '../delivery_detail_page.dart';

class DeliveryItemTile extends StatelessWidget {
  final bool arrivedLocal;

  final Delivery delivery;
  DeliveryItemTile({required this.delivery, required this.arrivedLocal});

  @override
  Widget build(BuildContext context) {
    String _receiver = "";
    String _sender = "";
    if (delivery.receiver != null) {
      _receiver = Helper.connectString([
        delivery.receiver!.name,
        delivery.receiver!.phone,
        delivery.receiver!.address
      ]);
    }
    if (delivery.sender != null) {
      _sender = Helper.connectString([
        delivery.sender!.name,
        delivery.sender!.phone,
        delivery.sender!.address
      ]);
    }
    final TextStyle _keyFieldTextStyle = Theme.of(context)
        .primaryTextTheme
        .titleSmall!
        .copyWith(color: Colors.grey[800], fontSize: 15);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => DeliveryDetailPage(
                      arrivedLocal: arrivedLocal,
                      delivery: delivery,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(top: 15, right: 15, left: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(standardBorderRadius)),
        child: Container(
          padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
              // color: Colors.yellow[100],
              border: Border(
                  left: BorderSide(
                      color: Theme.of(context).primaryColor, width: 5))),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          delivery.code,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleSmall!
                              .copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image(
                                height: 25,
                                fit: BoxFit.fitHeight,
                                image: NetworkImage(
                                  delivery.deliveryFromImage,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 28,
                              decoration: BoxDecoration(
                                  color: delivery.status == "pending"
                                      ? Colors.orange[700]
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(5)),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  delivery.status,
                                  // delivery.status == "pending"
                                  //     ? AppLocalizations.of(context)!
                                  //         .translate("pending")!
                                  //     : AppLocalizations.of(context)!
                                  //         .translate("completed")!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  delivery.total == null
                      ? Center()
                      : Text(
                          delivery.total!,
                          // style: Theme.of(context)
                          //     .primaryTextTheme
                          //     .subtitle1!
                          //     .copyWith(),
                          textScaleFactor: 1.1,
                        )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Container(
                      width: 110,
                      child: Text(
                        "sender",
                        style: _keyFieldTextStyle,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      ": $_sender",
                      style: _keyFieldTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                        width: 110,
                        child: Text("receiver", style: _keyFieldTextStyle)),
                    Expanded(
                        child: Text(
                      ":  $_receiver",
                      style: _keyFieldTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                        width: 110,
                        child: Text("description", style: _keyFieldTextStyle)),
                    Expanded(
                        child: Text(
                      // "name list",
                      ":  ${Helper.connectString(delivery.itemList.map((item) => item.name).toList())}",
                      style: _keyFieldTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
                // SizedBox(
                //   height: 5,
                // ),
                // Row(
                //   children: [
                //     Container(
                //         width: 110,
                //         child: Text("សម្គាល់", style: _keyFieldTextStyle)),
                //     Expanded(
                //         child: Text(
                //       ":  ${delivery.note}",
                //       style: _keyFieldTextStyle,
                //       maxLines: 1,
                //       overflow: TextOverflow.ellipsis,
                //     ))
                //   ],
                // ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                        width: 110,
                        child: Text("createdDate", style: _keyFieldTextStyle)),
                    Expanded(
                        child: Text(
                      ":  ${delivery.createDate}",
                      style: _keyFieldTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                        width: 110,
                        child: Text("arrivalDate", style: _keyFieldTextStyle)),
                    Expanded(
                        child: Text(
                      ":  ${delivery.arriveDate}",
                      style: _keyFieldTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
