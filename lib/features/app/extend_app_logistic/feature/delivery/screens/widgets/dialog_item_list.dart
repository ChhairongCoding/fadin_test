import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/item.dart';
import 'package:flutter/material.dart';

dialogItemList(
    {required BuildContext context, required List<Item> deliveryItems}) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: title == null ? null : Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...deliveryItems
                    .map((item) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${item.name}",
                                maxLines: 10,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                            SizedBox(height: 10),
                            item.type == null
                                ? Center()
                                : Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "type ${item.type}",
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                            item.cbm == null
                                ? Center()
                                : Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "CBM: ${item.cbm}",
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                            item.quantity == null
                                ? Center()
                                : Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "quantity ${item.quantity}",
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                            item.price == null
                                ? Center()
                                : Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "subtotal ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          "${item.price}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                            Divider(
                              thickness: 1,
                            )
                          ],
                        ))
                    .toList()
              ],
            ),
          ),
          actions: [
            // FlatButton(
            //   child: Text("OK"),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     onOk();
            //   },
            // )
          ],
        );
      });
}
