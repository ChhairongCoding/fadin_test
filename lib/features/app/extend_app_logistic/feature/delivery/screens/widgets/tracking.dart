import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/operation.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class Tracking extends StatelessWidget {
  final List<Operation> history;
  Tracking({required this.history});
  @override
  Widget build(BuildContext context) {
    TextStyle headTextStyle = TextStyle(color: Colors.grey[900]);
    TextStyle bodyTextStyle = TextStyle(color: Colors.grey[700]);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(standardBorderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "History",
            style: Theme.of(context).primaryTextTheme.titleMedium!.copyWith(),
          ),
          SizedBox(
            height: 15,
          ),
          ...history.reversed.map((data) {
            if (history.reversed.toList().indexOf(data) == 0) {
              return Container(
                margin: EdgeInsets.only(bottom: 5),
                child: IntrinsicHeight(
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Column(
                        children: [
                          DotIndicator(
                            color: Colors.green,
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
                                      Colors.grey,
                                      Colors.grey,
                                    ],
                                  ),
                                  color: Colors.grey[600],
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data.nameKh}",
                            // AppLocalizations.of(context)!.translate("china") ==
                            //         "ចិន"
                            //     ? "${data.nameKh}"
                            //     : "${data.nameEn}",
                            textScaleFactor: 1,
                            style: headTextStyle.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            data.date,
                            style: bodyTextStyle,
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
              );
            } else if (history.reversed.toList().indexOf(data) ==
                history.length - 1) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DotIndicator(color: Colors.grey[600]),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.nameKh,
                        // AppLocalizations.of(context)!.translate("china") ==
                        //         "ចិន"
                        //     ? data.nameKh
                        //     : data.nameEn,
                        textScaleFactor: 1,
                        style: headTextStyle.copyWith(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        data.date,
                        style: bodyTextStyle.copyWith(height: 1.5),
                      ),
                      // Text("dgdgdsgdgg dgdgsdgdddddddddddddddddd ddddddddddddd "),
                    ],
                  ))
                ],
              );
            } else {
              return Container(
                margin: EdgeInsets.only(bottom: 5),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          DotIndicator(color: Colors.grey[600]),
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
                                    colors: [Colors.grey, Colors.grey],
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
                            data.nameKh,
                            // AppLocalizations.of(context)!.translate("china") ==
                            //         "ចិន"
                            //     ? data.nameKh
                            //     : data.nameEn,
                            textScaleFactor: 1,
                            style: headTextStyle.copyWith(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            data.date,
                            style: bodyTextStyle,
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
              );
            }
          }).toList(),
        ],
      ),
    );
  }
}
