import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/helper/helper.dart';
import 'package:flutter/material.dart';
import 'dialog_item_list.dart';

class DeliveryDetailF2 extends StatelessWidget {
  final Delivery delivery;
  DeliveryDetailF2({required this.delivery});

  @override
  Widget build(BuildContext context) {
    final TextStyle _keyFieldTextStyle =
        TextStyle(color: Colors.black).copyWith(letterSpacing: 0.020);
    // Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
    //       letterSpacing: 0.020,
    //     );
    return GestureDetector(
      onTap: () {
        dialogItemList(context: context, deliveryItems: delivery.itemList);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(standardBorderRadius)),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Row(
              //   children: [
              //     Container(
              //       width: 110,
              //       child: Text(
              //         "Quantity",
              //         style: _keyFieldTextStyle,
              //       ),
              //     ),
              //     Text(":  "),
              //     Expanded(
              //         child: Text(
              //       "2 packages",
              //       style: _keyFieldTextStyle,
              //       maxLines: 2,
              //       overflow: TextOverflow.ellipsis,
              //     ))
              //   ],
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              Row(
                children: [
                  Container(
                      width: 110,
                      child: Text("description", style: _keyFieldTextStyle)),
                  Text(":  "),
                  Expanded(
                      child: Text(
                    // "nam list",
                    Helper.connectString(
                        delivery.itemList.map((item) => item.name).toList()),
                    style: _keyFieldTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
              SizedBox(
                height: 5,
              ),
              delivery.height == ""
                  ? Center()
                  : Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Container(
                              width: 110,
                              child:
                                  Text("height cm", style: _keyFieldTextStyle)),
                          Text(":  "),
                          Expanded(
                              child: Text(
                            " ${delivery.height}",
                            style: _keyFieldTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ),
              // SizedBox(
              //   height: 5,
              // ),

              delivery.width == ""
                  ? Center()
                  : Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Container(
                              width: 110,
                              child:
                                  Text("width cm", style: _keyFieldTextStyle)),
                          Text(":  "),
                          Expanded(
                              child: Text(
                            " ${delivery.width}",
                            style: _keyFieldTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ),

              delivery.length == ""
                  ? Center()
                  : Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Container(
                              width: 110,
                              child:
                                  Text("length cm", style: _keyFieldTextStyle)),
                          Text(":  "),
                          Expanded(
                              child: Text(
                            " ${delivery.length}",
                            style: _keyFieldTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ),

              delivery.weight == ""
                  ? Center()
                  : Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Container(
                              width: 110,
                              child:
                                  Text("weight kg", style: _keyFieldTextStyle)),
                          Text(":  "),
                          Expanded(
                              child: Text(
                            " ${delivery.weight}",
                            style: _keyFieldTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ),

              // Row(
              //   children: [
              //     Container(
              //         width: 110,
              //         child: Text("Arrival Date", style: _keyFieldTextStyle)),
              //     Text(":  "),
              //     Expanded(
              //         child: Text(
              //       "10-19-2021",
              //       style: _keyFieldTextStyle.copyWith(color: Colors.green[800]),
              //       maxLines: 1,
              //       overflow: TextOverflow.ellipsis,
              //     ))
              //   ],
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              Row(
                children: [
                  Container(
                      width: 110,
                      child: Text("createdDate", style: _keyFieldTextStyle)),
                  Text(":  "),
                  Expanded(
                      child: Text(
                    delivery.createDate,
                    style:
                        _keyFieldTextStyle.copyWith(color: Colors.orange[800]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
              SizedBox(
                height: 5,
              ),
              delivery.arriveDate == null || delivery.arriveDate == ""
                  ? Center()
                  : Row(
                      children: [
                        Container(
                            width: 110,
                            child:
                                Text("arrivalDate", style: _keyFieldTextStyle)),
                        Text(":  "),
                        Expanded(
                            child: Text(
                          "${delivery.arriveDate}",
                          style: _keyFieldTextStyle.copyWith(
                              color: Colors.green[800]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    ),
            ]),
          ],
        ),
      ),
    );
  }
}
