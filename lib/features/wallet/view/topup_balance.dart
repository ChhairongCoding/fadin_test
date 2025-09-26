import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/custom_dialog.dart';
import 'package:fardinexpress/features/wallet/controller/wallet_controller.dart';
import 'package:fardinexpress/features/wallet/view/widget/payment_widget.dart';
import 'package:fardinexpress/shared/bloc/file_pickup/file_pickup_bloc.dart';
import 'package:fardinexpress/shared/bloc/item_indexing.dart/item_indexing_bloc.dart';
import 'package:fardinexpress/utils/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class TopupBalance extends StatefulWidget {
  final String title;
  const TopupBalance({Key? key, required this.title}) : super(key: key);

  @override
  State<TopupBalance> createState() => _TopupBalanceState();
}

class _TopupBalanceState extends State<TopupBalance> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FilePickupBloc? _filePickupBloc;
  ItemIndexingBloc? paymentMethodIndexingBloc;

  final _noteCtr = TextEditingController();
  final _amountCtr = TextEditingController();

  WalletController _walletController =
      Get.put(WalletController(), tag: "topup");

  _onTopup() {
    if (_key.currentState!.validate()) {
      // _walletBloc.add(TopupWallet(
      //     note: _noteCtr.text,
      //     paymentMethod: paymentMethodList[paymentMethodIndexingBloc!.state]
      //         ["name"],
      //     amount: _amountCtr.text,
      // image: _filePickupBloc!.state));
      _walletController.toRequestTopup(
          note: _noteCtr.text,
          paymentMethod: paymentMethodList[paymentMethodIndexingBloc!.state]
              ["name"],
          amount: _amountCtr.text,
          image: _filePickupBloc!.state);
    }
  }

  @override
  void initState() {
    _filePickupBloc = FilePickupBloc();
    paymentMethodIndexingBloc = ItemIndexingBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocProvider(
                    create: (BuildContext context) =>
                        paymentMethodIndexingBloc!,
                    child: BlocBuilder(
                      bloc: paymentMethodIndexingBloc,
                      builder: (c, dynamic state) {
                        return _paymentMethodWidget(context);
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text(
                            "Top UpAmount",
                            // AppLocalizations.of(context)!
                            //     .translate("topUpAmount")!,
                            textScaleFactor: 1.1,
                          )),
                      Expanded(
                        flex: 7,
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1.0,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          controller: _amountCtr,
                          autocorrect: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Amount is required.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      // hintText: AppLocalizations.of(context)!.translate("note"),
                      hintText: "Note",
                      hintStyle: TextStyle(fontSize: 16.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                    ),
                    controller: _noteCtr,
                    autocorrect: false,
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'new password is required.';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: 15.0),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // color: Theme.of(context).buttonColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upload TranPhoto"
                              // AppLocalizations.of(context)!
                              //   .translate("uploadTransactionPhoto")!
                              ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          GestureDetector(
                            onTap: () {
                              _showPicker(context);
                              // uploadPhoto(photo: _image);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.width / 3,
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: BlocBuilder(
                                    bloc: _filePickupBloc,
                                    builder: (context, dynamic state) {
                                      return FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: (state == null)
                                              ? Icon(
                                                  Icons.add_a_photo_outlined,
                                                  color: Colors.grey[300],
                                                )
                                              : Image.file(state));
                                    },
                                  )),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).primaryColor),
          child: ElevatedButton(
              onPressed: () {
                if (_filePickupBloc!.state == null) {
                  customDialog(
                      context, "", Text("Please choose transfer image"), () {});
                } else {
                  _onTopup();
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, elevation: 0),
              child: Text(
                "Submission",
                // AppLocalizations.of(context)!.translate("deposite")!,
                style: TextStyle(color: Colors.white),
                textScaleFactor: 1.2,
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _paymentMethodWidget(BuildContext context) {
    return Builder(
      builder: (c) {
        return BlocBuilder(
          bloc: BlocProvider.of<ItemIndexingBloc>(c),
          builder: (context, dynamic state) {
            return GestureDetector(
              onTap: () {
                paymentMethodDialog(c);
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Theme.of(context).buttonColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Transfer Method",
                        // AppLocalizations.of(context)!
                        //   .translate("chooseTransferMethod")!
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      (paymentMethodIndexingBloc!.state == (-1))
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Choose Here",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                Icon(Icons.arrow_drop_down)
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  flex: 20,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Image(
                                      width: 15,
                                      height: 15,
                                      image: AssetImage(
                                          paymentMethodList[state]["image"]),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 80,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(paymentMethodList[state]["name"],
                                            textScaleFactor: 1.1),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            paymentMethodList[state]
                                                ["description"],
                                            textScaleFactor: 1.1),
                                      ],
                                    )),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                    ],
                  )),
            );
          },
        );
      },
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        Helper.imgFromGallery((image) {
                          _filePickupBloc!.add(image);
                        });
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      Helper.imgFromCamera((image) {
                        _filePickupBloc!.add(image);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _filePickupBloc!.close();
    paymentMethodIndexingBloc!.close();
    super.dispose();
  }
}
