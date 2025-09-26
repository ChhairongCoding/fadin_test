import 'package:fardinexpress/features/auth/login/bloc/register_bloc.dart';
import 'package:fardinexpress/features/auth/login/bloc/register_event.dart';
import 'package:fardinexpress/features/auth/login/bloc/register_state.dart';
import 'package:fardinexpress/features/otp/view/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController? _nameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _passwordController;
  final _formKey = GlobalKey<FormState>();

  Future<void> _errorDialog(String? title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('warning'.tr),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(title!),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearTextInput() {
    _nameController!.clear();
    _phoneNumberController!.clear();
    _passwordController!.clear();
  }

  @override
  void initState() {
    EasyLoading.instance..toastPosition = EasyLoadingToastPosition.bottom;
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController!.dispose();
    _phoneNumberController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is Registering) {
            EasyLoading.show(status: 'loading...');
          } else if (state is Registered) {
            EasyLoading.dismiss();
            Get.off(() => OTPForm(
                token: state.token!.toString(),
                phone: state.phone!.toString()));
            clearTextInput();
          } else if (state is ErrorRegistering) {
            EasyLoading.dismiss();
            _errorDialog(state.error);
          }
        },
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "name".tr),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "phone".tr),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "required";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                decoration: InputDecoration(labelText: "password".tr),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "required";
                  } else if (value.length < 8) {
                    return "password lenght must bigger than 8";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(labelText: "confirmNewPassword".tr),
                validator: (value) {
                  if (value!.isEmpty || value != _passwordController!.text) {
                    return "confirm password is invalid";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<RegisterBloc>(context).add(
                            RegisterPressed(
                                name: _nameController!.text,
                                phoneNumber: _phoneNumberController!.text,
                                password: _passwordController!.text));
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      "register".tr,
                      textScaleFactor: 1.3,
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ])));
  }
}
