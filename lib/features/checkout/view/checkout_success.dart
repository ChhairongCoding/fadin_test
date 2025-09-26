import 'package:fardinexpress/features/express/view/delivery_history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SuccessScreenType { deliveryType, otherType }

class SuccessfulScreen extends StatelessWidget {
  final SuccessScreenType successScreenType;
  const SuccessfulScreen({Key? key, required this.successScreenType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onWillPop: () async => false,
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                ))
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 65,
                child: Container(
                  // color: Colors.red[100],
                  // width: MediaQuery.of(context).size.width,
                  // height: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: double.infinity,
                        child: Container(),
                        // color: Colors.green[100],
                        // child: SvgPicture.asset(data["bgSvg"]
                        // )
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(),
                          ),
                          Expanded(
                              flex: 2,
                              child: AspectRatio(
                                aspectRatio: 4 / 4,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 5,
                                            color: Colors.green[50]!)),
                                    child:
                                        Icon(Icons.check, color: Colors.white),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Center(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "success".tr,
                            textScaleFactor: 2,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              "orderSuccess".tr,
                              textScaleFactor: 1.1,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            "thankU".tr,
                            textScaleFactor: 1.1,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 20),
                      child: AspectRatio(
                        aspectRatio: 10 / 1.3,
                        child: Container(
                            width: double.infinity,
                            height: 45,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.red;
                                    }
                                    return Colors.green;
                                  },
                                ),
                              ),
                              onPressed: () {
                                // data["btnNavOnPress"]();
                                if (successScreenType ==
                                    SuccessScreenType.deliveryType) {
                                  Get.off(() => DeliveryHistoryPage(
                                        initIndex: 0,
                                        transportType: 'express',
                                      ));
                                } else {
                                  Get.back();
                                  Get.back();
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  (successScreenType ==
                                          SuccessScreenType.deliveryType)
                                      ? "checkHistory".tr
                                      : "done".tr,
                                  // AppLocalizations.of(context)!
                                  //     .translate('success')
                                  //     .toUpperCase(),
                                  textScaleFactor: 1.2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, letterSpacing: 1),
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
