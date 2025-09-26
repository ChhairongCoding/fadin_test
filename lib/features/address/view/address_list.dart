import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/address/controller/address_controller.dart';
import 'package:fardinexpress/features/address/view/add_address_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class AddressList extends StatelessWidget {
  final bool isCheckout;
  AddressList({Key? key, required this.isCheckout}) : super(key: key);

  final AddressController _addressController = Get.put(AddressController());
  final _accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("address".tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_addressController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Container(
            child: ListView.builder(
              itemCount: _addressController.addressList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: (_addressController.addressList[index].defaultAddress
                              .toString() ==
                          "t")
                      ? ListTile(
                          onTap: () => {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          tileColor: Colors.grey[200],
                          subtitle: Text(_addressController
                              .addressList[index].description
                              .toString()),
                          title: Text(_addressController.addressList[index].name
                              .toString()),
                          trailing: (_addressController
                                      .addressList[index].defaultAddress
                                      .toString() ==
                                  "t")
                              ? Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.blue),
                                  child: Text(
                                    "Default",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(
                                  child: Text(""),
                                ))
                      : Slidable(
                          endActionPane:
                              ActionPane(motion: ScrollMotion(), children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              flex: 1,
                              onPressed: (context) =>
                                  _addressController.toDeleteLocation(
                                      addressId: _addressController
                                          .addressList[index].id
                                          .toString()),
                              backgroundColor: Colors.red[300]!,
                              foregroundColor: Colors.white,
                              icon: Icons.delete_forever,
                              label: "Remove",
                            ),
                            // SlidableAction(
                            //   // An action can be bigger than the others.
                            //   flex: 1,
                            //   onPressed: (context) => Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               EditLocationPage(
                            //                   locationModel:
                            //                       locationBloc
                            //                               .location[
                            //                           index]))),
                            //   backgroundColor: Colors.green[300]!,
                            //   foregroundColor: Colors.white,
                            //   icon: Icons.edit_location_outlined,
                            //   label: AppLocalizations.of(context)!
                            //       .translate("edit")!,
                            // ),
                          ]),
                          child: ListTile(
                              onTap: () {
                                _addressController.toSelectLocation(
                                    addressId: _addressController
                                        .addressList[index].id
                                        .toString());
                                if (this.isCheckout == true) {
                                  _accountController.addressName.value =
                                      _addressController
                                          .addressList[index].description;
                                  _accountController.addressId.value =
                                      _addressController.addressList[index].id!
                                          .toString();
                                  Get.back();
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              tileColor: Colors.grey[200],
                              subtitle: Text(_addressController
                                  .addressList[index].description
                                  .toString()),
                              title: Text(_addressController
                                  .addressList[index].name
                                  .toString()),
                              trailing: (_addressController
                                          .addressList[index].defaultAddress
                                          .toString() ==
                                      "t")
                                  ? Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Colors.blue),
                                      child: Text(
                                        "Default",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Container(
                                      child: Text(""),
                                    )),
                        ),
                );
              },
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add_outlined,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () => Get.to(() => AddAddressForm())),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
