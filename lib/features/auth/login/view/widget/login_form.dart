import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_event.dart';
import 'package:fardinexpress/features/auth/login/bloc/login_bloc.dart';
import 'package:fardinexpress/features/auth/login/bloc/login_event.dart';
import 'package:fardinexpress/features/auth/login/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController? _phoneNumberController;
  TextEditingController? _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is Logging) {
          EasyLoading.show(status: 'loading...');
        }
        if (state is Logged) {
          EasyLoading.dismiss();
          BlocProvider.of<AuthenticationBloc>(context)
              .add(UserLoggedIn(token: state.token));
          Navigator.pop(context);
        }
        if (state is ErrorLogin) {
          EasyLoading.dismiss();
          EasyLoading.showToast(state.message);
        }
      },
      child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset("assets/lang/cambodia-flag.png"),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          // prefix: Text("+855"),
                          suffixIcon: Icon(Icons.person),
                          labelText: "phone".tr),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "required";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Icon(
                  Icons.vpn_key_outlined,
                  color: Colors.amber[900],
                )),
                Expanded(
                  flex: 9,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: _toggle,
                              icon: Icon(Icons.remove_red_eye_rounded)),
                          labelText: "password".tr),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "required";
                        }
                        return null;
                      },
                      obscureText: _obscureText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     padding: EdgeInsets.all(15),
            //     child: Text(
            //       "Forget ChangePassword?",
            //       textAlign: TextAlign.center,
            //       style: TextStyle(color: Colors.red),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<LoginBloc>(context).add(LoginPressed(
                          phoneNumber: _phoneNumberController!.text,
                          // _phoneNumberController!.text[0].toString() == "0"
                          //     ? _phoneNumberController!.text.substring(1)
                          //     : _phoneNumberController!.text,
                          password: _passwordController!.text));
                      // print(_phoneNumberController!.text.substring(1));
                    }
                  },
                  child: Text(
                    "login".tr,
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ])),
    );
  }
}
