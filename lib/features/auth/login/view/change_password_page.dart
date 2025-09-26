import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:fardinexpress/features/auth/login/controller/create_new_password_ctr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({Key? key}) : super(key: key);

  final CreateNewPasswordController _controller =
      Get.put(CreateNewPasswordController(), tag: "changePassword");

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPassCtl = TextEditingController();

  final TextEditingController _newPassCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              SizedBox(height: 20),
              Text(
                "changePassword".tr,
                // AppLocalizations.of(context)!.translate("changePassword")!,
                textAlign: TextAlign.start,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textScaleFactor: 2,
              ),
              SizedBox(height: 20),
              Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    TextFormField(
                      controller: _currentPassCtl,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "currentPass".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "required".tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _newPassCtl,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "newPassword".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "newPassword".tr;
                        } else if (value.length < 8) {
                          return "password lenght must bigger than 8".tr;
                        } else {
                          return null;
                        }
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "confirmNewPassword".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value != _newPassCtl.text) {
                          return "confirm password is invalid".tr;
                        }
                        return null;
                      },
                    ),
                    // SizedBox(height: 5),
                    SizedBox(height: 30),
                    Container(
                      width: Get.width * 0.5,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(standardBorderRadius),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _controller.toChangePassword(_currentPassCtl.text,
                                  _newPassCtl.text, context);
                            }
                          },
                          child: Text(
                            "change".tr,
                            textScaleFactor: 1.2,
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ])),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
