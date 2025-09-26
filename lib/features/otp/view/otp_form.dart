import 'package:fardinexpress/features/otp/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPForm extends StatelessWidget {
  final String token;
  final String phone;
  const OTPForm({Key? key, required this.token, required this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OtpController _otpController = Get.put(OtpController());
    final otpCtl = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 2,
                child: Icon(
                  Icons.message,
                  size: 70.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                "Verication Code",
                // AppLocalizations.of(context)!.translate('verificationCode')!,
                textScaleFactor: 1.6,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                child: Text(
                  "Enter Send OTP Code",
                  // AppLocalizations.of(context)!.translate('enterSendOtp')!,
                  textScaleFactor: 1.2,
                ),
              ),
              PinCodeTextField(
                keyboardType: TextInputType.number,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                cursorColor: Colors.grey[200],
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,

                pinTheme: PinTheme(
                  selectedColor: Colors.grey,
                  // selectedFillColor: Colors.white,
                  inactiveColor: Colors.grey[300],
                  // disabledColor: Colors.grey,
                  activeColor: Colors.grey[200],
                  //inactiveFillColor: Colors.purple,
                  shape: PinCodeFieldShape.underline,
                  //  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  // activeFillColor: Colors.grey[200],
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                // enableActiveFill: true,
                // errorAnimationController: errorController,
                controller: otpCtl,
                onCompleted: (v) {
                  print("Completed input");
                  if (_otpController.isLoading.value == false) {
                    _otpController.verifyUser(
                        phone, otpCtl.text, token, context);
                  }
                },
                onChanged: (value) {},
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                appContext: context,
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not received code yet?",
                    // "${AppLocalizations.of(context)!.translate('notYetReceiveCode')!}?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
