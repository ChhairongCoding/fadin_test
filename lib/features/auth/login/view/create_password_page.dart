import 'package:fardinexpress/features/auth/login/controller/create_new_password_ctr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewPasswordPage extends StatelessWidget {
  final String reference;
  CreateNewPasswordPage({Key? key, required this.reference}) : super(key: key);

  final GlobalKey<FormState> _mykey = GlobalKey<FormState>();
  final passwordCtl = TextEditingController();
  final confirmNewPassCtl = TextEditingController();
  final CreateNewPasswordController _createNewPasswordController =
      Get.put(CreateNewPasswordController());

  @override
  Widget build(BuildContext context) {
    void _onCreateNewPassword() {
      if (_mykey.currentState!.validate()) {
        _createNewPasswordController.toCreateNewPassword(
            reference, passwordCtl.text, "ANAKUT", context);
      } else {
        print("request isn't validated");
      }
    }

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
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 2,
                    child: Icon(
                      Icons.vpn_key_outlined,
                      size: 70.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    "Create new password",
                    // AppLocalizations.of(context)!
                    //     .translate("createNewPassword")!,
                    textScaleFactor: 1.6,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 26.0,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "New Password",
                        // AppLocalizations.of(context)!
                        //     .translate("newPassword")!,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.grey[100]!,
                            width: 1.0,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        border: InputBorder.none),
                    controller: passwordCtl,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Confirm New Password",
                        // AppLocalizations.of(context)!
                        //     .translate("confirmNewPassword")!,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.grey[100]!,
                            width: 1.0,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        border: InputBorder.none),
                    controller: confirmNewPassCtl,
                    validator: (value) {
                      if (value != passwordCtl.text) {
                        return 'Password not match !';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // BlocListener(
      //   bloc: createNewPasswordBloc,
      //   listener: (context, state) {
      //     if (state is CreateNewPasswordLoading) {
      //       EasyLoading.show(status: 'loading...');
      //     }
      //     if (state is CreateNewPasswordLoaded) {
      //       EasyLoading.dismiss();
      //       _successMessage();
      //     } else if (state is CreateNewPasswordError) {
      //       EasyLoading.dismiss();
      //       _errorMessage(state.error);
      //     }
      //   },
      //   child:
      // ),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              "Submit",
              // AppLocalizations.of(context)!.translate("submit")!,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _onCreateNewPassword()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
