import 'package:cached_network_image/cached_network_image.dart';
import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/bloc/warehouse_address_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/bloc/warehouse_address_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/bloc/warehouse_address_state.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/error_sneakbar.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/standard_appbar.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class WarehouseAddressPage extends StatelessWidget {
  const WarehouseAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (c) => WarehouseAddressBloc()..add(FetchWarehouseAddresses()),
        child: WarehouseAddressPageBody());
  }
}

class WarehouseAddressPageBody extends StatelessWidget {
  WarehouseAddressPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<AccountBloc>(context).add(FetchAccountStarted());
    AccountController _controller = Get.find<AccountController>();
    return Scaffold(
        appBar: standardAppBar(context, "Warehouse Address"),
        body: Obx(() {
          if (_controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return BlocConsumer<WarehouseAddressBloc, WarehouseAddressState>(
              listener: (c, state) {
                if (state is ErrorFetchingWarehouseAddresses) {
                  errorSnackBar(text: state.error, context: context);
                }
              },
              builder: (c, state) {
                if (state is ErrorFetchingWarehouseAddresses) {
                  return Center(
                    child: TextButton(
                      onPressed: () {
                        BlocProvider.of<WarehouseAddressBloc>(context)
                            .add(FetchWarehouseAddresses());
                      },
                      child: Text("Retry"),
                    ),
                  );
                } else if (state is FetchedWarehouseAddresses) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          "Please add the following as your delivery address when you perform check-out on any online shopping platform.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                            // color: Theme.of(context).primaryColor
                          ),
                        ),
                        SizedBox(height: 15),
                        ...state.addressList
                            .map(
                              (address) => Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: _addressFraction(
                                    imagePath: address.image == null
                                        ? "assets/lang/lang_kh.png"
                                        : address.image!,
                                    // (address.note == null ||
                                    //         address.note!.toLowerCase() ==
                                    //             "china")
                                    //     ? "assets/icons/countries/china.png"
                                    //     : "assets/icons/countries/thailand.jpg",
                                    name: "${address.name}",
                                    // (address.note == null ||
                                    //         address.note!.toLowerCase() ==
                                    //             "china")
                                    //     ? AppLocalizations.of(context)!
                                    //         .translate("addressChina")!
                                    //     : AppLocalizations.of(context)!
                                    //         .translate("addressThailand")!,
                                    child: Column(children: [
                                      _addressRowTile(
                                          "Name",
                                          "${address.name}".replaceAll("YOURID",
                                              _controller.accountInfo.id)),
                                      SizedBox(height: 5),
                                      _addressRowTile(
                                          "Phone", "${address.phone}"),
                                      SizedBox(height: 5),
                                      // _addressRowTile(
                                      //     Helper()
                                      //         .translate(context, "address"),
                                      //     "${address.warehouseAddress}"
                                      //         .replaceAll("YOURID",
                                      //             userState.user.userId!)),
                                      address.warehouseAddress
                                                  .split("SPLIT")
                                                  .length ==
                                              0
                                          ? _addressRowTile(
                                              "Address",
                                              "${address.warehouseAddress}"
                                                  .replaceAll(
                                                      "YOURID",
                                                      _controller
                                                          .accountInfo.id))
                                          : Column(
                                              children: [
                                                _addressRowTile("Address", ""),
                                                ...address.warehouseAddress
                                                    .split("SPLIT")
                                                    .map((ad) =>
                                                        _addressRowTile(
                                                            null,
                                                            "$ad".replaceAll(
                                                                "YOURID",
                                                                _controller
                                                                    .accountInfo
                                                                    .id))),
                                              ],
                                            ),

                                      SizedBox(height: 5),
                                      // (address.province == null)
                                      //     ? Center()
                                      //     : _addressRowTile(
                                      //         Helper().translate(
                                      //             context, "province"),
                                      //         "${address.province}"),
                                      // (address.subDistrict == null)
                                      //     ? Center()
                                      //     : _addressRowTile(
                                      //         Helper().translate(
                                      //             context, "subDistrict"),
                                      //         "${address.subDistrict}"
                                      //             .replaceAll(
                                      //                 "YOURID",
                                      //                 userState
                                      //                     .user.userId!)),

                                      // _addressRowTile(
                                      //     Helper()
                                      //         .translate(context, "zipcode"),
                                      //     "${address.zipCode}"),
                                    ])),
                              ),
                            )
                            .toList()
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          }
        }));
  }

  Widget _addressFraction(
      {required String name,
      required String imagePath,
      required Column child}) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(standardBorderRadius),
            color: Colors.grey[200]),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      errorWidget: (a, b, c) {
                        return Center();
                      },
                      imageUrl: imagePath,
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(name,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 0),
            child
          ],
        ),
      ),
    );
  }

  Widget _addressRowTile(String? key, String value) {
    return Builder(
      builder: (context) {
        return Row(
          // mainAxisAlignment: <,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    key == null ? "" : "$key : ",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Container(
                    padding: EdgeInsets.only(),
                    child: Text(
                      value.replaceAll("BREAK", "\n"),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            value == ""
                ? Center()
                : SizedBox(
                    width: 25,
                    height: 25,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Icon(
                          Icons.copy_outlined,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Clipboard.setData(new ClipboardData(
                                  text: value.replaceAll("BREAK", "\n")))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text((key == null ? "" : "$key") +
                                  " copied to clipboard"),
                              duration: Duration(milliseconds: 1000),
                            ));
                          });
                        }),
                  )
          ],
        );
      },
    );
  }
}
