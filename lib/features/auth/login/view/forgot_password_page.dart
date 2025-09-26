import 'package:fardinexpress/features/otp/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordForm extends StatelessWidget {
  ForgetPasswordForm({Key? key}) : super(key: key);

  final GlobalKey<FormState> _mykey = GlobalKey<FormState>();
  final OtpController _otpController = Get.put(OtpController());
  final phoneController = TextEditingController();

  void _onConfirmPhoneNumber() {
    if (_mykey.currentState!.validate()) {
      _otpController.confirmUserPhoneNumber(
          phoneController.text, "ANAKUT", "forgot");
    } else {
      print("request faild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _mykey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 2,
                  child: Icon(
                    Icons.lock_outline,
                    size: 70.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  "${'forgotPassword'.tr}?",
                  // "${AppLocalizations.of(context)!.translate("forgotPassword")!}?",
                  textScaleFactor: 1.6,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  "enterPhoneToVerify".tr,
                  // AppLocalizations.of(context)!
                  //     .translate("enterPhoneToVerify")!,
                  textScaleFactor: 1.2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 26.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                            // color: Colors.red,
                            border: Border(
                                right: BorderSide(
                          width: 1.0,
                          color: Colors.grey[300]!,
                        ))),
                        child: AspectRatio(
                          aspectRatio: 2,
                          child: Image.asset("assets/lang/lang_kh.png"),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: TextFormField(
                        style: TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            hintText: "010 xxx xxx",
                            fillColor: Colors.transparent,
                            filled: true,
                            isDense: true,
                            border: InputBorder.none),
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'requred';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              "continue".tr,
              // AppLocalizations.of(context)!.translate("continue")!,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _onConfirmPhoneNumber()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
