import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/controller/branch_address_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/bloc/delivery_listing_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/bloc/delivery_listing_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/bloc/delivery_listing_state.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/repositories/delivery_listing_repository.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/screens/widgets/delivery_item_tile.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/error_sneakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DeliveryList extends StatefulWidget {
  final bool arrivedLocal;
  final DeliveryListingRepository deliveryListingRepository;
  final String countryId;
  DeliveryList(
      {required this.deliveryListingRepository,
      required this.arrivedLocal,
      required this.countryId});

  @override
  _DeliveryListState createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  final BranchAddressController _countryController =
      Get.put(BranchAddressController(), tag: "country");
  late final DeliveryListingBloc deliveryListingBloc = DeliveryListingBloc(
      deliveryListingRepository: widget.deliveryListingRepository);
  final RefreshController _refreshController = RefreshController();
  // BranchAddressController _countryController = Get.put(BranchAddressController(), tag: "country");
  // Future<bool?> selectWidgets(Widget dynamicWidget, String title) {
  //   return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(title),
  //           content: dynamicWidget,
  //           actions: [
  //             ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   // if (_zoneController.zoneList.length != 0) {
  //                   //   _zoneController.zoneList.clear();
  //                   // } else {}
  //                   // Navigator.pop(context);
  //                 },
  //                 child: Text("Done"))
  //           ],
  //         );
  //       });
  // }

  @override
  void initState() {
    // deliveryListingBloc = DeliveryListingBloc(
    //     deliveryListingRepository: widget.deliveryListingRepository)
    deliveryListingBloc.add(FetchDeliveryList(additionalArg: widget.countryId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool?> selectWidgets(Widget dynamicWidget, String title) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // backgroundColor: Theme.of(context).primaryColor,
              title: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2.0)),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              content: dynamicWidget,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // if (_zoneController.zoneList.length != 0) {
                      //   _zoneController.zoneList.clear();
                      // } else {}
                      // Navigator.pop(context);
                    },
                    child: Text("Done"))
              ],
            );
          });
    }

    return BlocListener(
      bloc: deliveryListingBloc,
      listener: (c, state) {
        if (state is FetchedDeliveryList) {
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
                onPressed: () => selectWidgets(countryListWidget(), "Country"),
                icon: Icon(
                  Icons.filter_list_sharp,
                  color: Colors.grey[800],
                )),
          ),
          Expanded(
            child: SmartRefresher(
                onRefresh: () {
                  deliveryListingBloc.deliveryList.clear();
                  deliveryListingBloc.page = 1;
                  _refreshController.refreshCompleted();
                  deliveryListingBloc
                      .add(FetchDeliveryList(additionalArg: widget.countryId));
                },
                onLoading: () {
                  // deliveryListingBloc
                  //     .add(FetchDeliveryList(additionalArg: widget.countryId));
                },
                enablePullDown: true,
                enablePullUp: true,
                controller: _refreshController,
                child: BlocConsumer(
                  bloc: deliveryListingBloc,
                  listener: (c, state) {
                    if (state is ErrorFetchingDeliveryList) {
                      errorSnackBar(
                          text: state.error.toString(), context: context);
                    }
                  },
                  builder: (c, state) {
                    print(state);
                    print(deliveryListingBloc.deliveryList.length);

                    if (deliveryListingBloc.deliveryList.length == 0) {
                      if (state is ErrorFetchingDeliveryList) {
                        return Center(
                          child: TextButton(
                            onPressed: () {
                              deliveryListingBloc.add(FetchDeliveryList(
                                  additionalArg: widget.countryId));
                            },
                            child: Text("Retry"),
                          ),
                        );
                      } else if (state is FetchedDeliveryList) {
                        return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  AssetImage(
                                      "assets/extend_assets/icons/empty-box.png"),
                                  size: 120,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "noDataFound".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.grey[500]),
                                )
                              ]),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    } else {
                      return SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: deliveryListingBloc.deliveryList.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return
                                // ListTile(
                                //   title:
                                //       Text(deliveryListingBloc.deliveryList[index].note),
                                // );

                                DeliveryItemTile(
                                    arrivedLocal: widget.arrivedLocal,
                                    delivery: deliveryListingBloc
                                        .deliveryList[index]);
                          },
                        ),
                      );
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget countryListWidget() {
    return Container(
        width: 300,
        height: 500,
        child: Obx(() {
          if (_countryController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: _countryController.countryList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // receiverLat.text = _zoneController.zoneList[index].lat;
                      // receiverLong.text = _zoneController.zoneList[index].long;
                      // zoneCtr.text = _zoneController.zoneList[index].name;
                      // feeCtr.text =
                      //     'Book Now  Total : ${_zoneController.zoneList[index].fee} \$';
                      Navigator.pop(context);
                      deliveryListingBloc.add(FetchDeliveryList(
                          additionalArg: _countryController
                              .countryList[index].id
                              .toString()));
                    },
                    title: Text(
                      _countryController.countryList[index].name.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    // subtitle: Text(_countryController
                    //         .countryList[index].serviceFee
                    //         .toString() +
                    //     "\$"),
                  );
                });
          }
        }));
  }
  //  Widget countryListWidget() {
  //   return Container(
  //       width: 300,
  //       height: 500,
  //       child: Obx(() {
  //         if (_countryController.isLoading.value) {
  //           return Center(child: CircularProgressIndicator());
  //         } else {
  //           return ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: _countryController.countryList.length,
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   onTap: () {
  //                     // receiverLat.text = _zoneController.zoneList[index].lat;
  //                     // receiverLong.text = _zoneController.zoneList[index].long;
  //                     // zoneCtr.text = _zoneController.zoneList[index].name;
  //                     // feeCtr.text =
  //                     //     'Book Now  Total : ${_zoneController.zoneList[index].fee} \$';
  //                     Navigator.pop(context);
  //                   },
  //                   title: Text(
  //                     _countryController.countryList[index].name.toString(),
  //                     style: TextStyle(color: Colors.black),
  //                   ),
  //                   subtitle: Text(_countryController.countryList[index].serviceFee.toString() + "\$"),
  //                 );
  //               });
  //         }
  //       }));
  // }
}
