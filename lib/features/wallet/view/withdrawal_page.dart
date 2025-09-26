import 'package:fardinexpress/features/wallet/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawFormPage extends StatefulWidget {
  final String title;
  WithdrawFormPage({Key? key, required this.title}) : super(key: key);

  @override
  State<WithdrawFormPage> createState() => _WithdrawFormPageState();
}

class _WithdrawFormPageState extends State<WithdrawFormPage> {
  final GlobalKey<FormState> _mykey = GlobalKey<FormState>();

  WalletController _walletController =
      Get.put(WalletController(), tag: "withdrawal");

  final _amountController = TextEditingController();

  final _noteController = TextEditingController();

  _onRequestWithdraw() {
    if (_mykey.currentState!.validate()) {
      _walletController.toWithdraw(amount: _amountController.text);
    }
  }

  void _clearTextInput() {
    _amountController.clear();
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: Form(
          key: _mykey,
          child: Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 14.0),
                    decoration: InputDecoration(
                      icon: Icon(Icons.local_atm),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
                      labelText: 'Amount',
                      hintStyle: TextStyle(fontSize: 16.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                    ),
                    controller: _amountController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Amount is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 14.0),
                    decoration: InputDecoration(
                      icon: Icon(Icons.edit),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
                      labelText: 'Remark',
                      hintStyle: TextStyle(fontSize: 16.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                    ),
                    controller: _noteController,
                    autocorrect: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'remark is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                      ),
                      child: Text(
                        "Send",
                        style: TextStyle(color: Colors.white),
                        textScaleFactor: 1.2,
                      ),
                      onPressed: _onRequestWithdraw,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _clearTextInput();
    super.dispose();
  }
}
