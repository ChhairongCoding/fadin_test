import 'package:fardinexpress/features/auth/login/bloc/login_bloc.dart';
import 'package:fardinexpress/features/auth/login/view/forgot_password_page.dart';
import 'package:fardinexpress/features/auth/login/view/widget/login_form.dart';
import 'package:fardinexpress/features/auth/login/view/widget/logo_holder.dart';
import 'package:fardinexpress/features/auth/login/view/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key, this.isLogin = true}) : super(key: key);
  final bool isLogin;
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool? isLogin;
  @override
  void initState() {
    isLogin = widget.isLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
        // BlocProvider<RegisterBloc>(]
        //     create: (BuildContext context) => RegisterBloc())
      ],
      child: Scaffold(
        appBar: AppBar(
          // brightness: Theme.of(context).brightness,
          backgroundColor: Colors.green,
          elevation: 0,
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // actions: [
          //   AspectRatio(
          //       aspectRatio: 1,
          //       child: GestureDetector(
          //         onTap: () => languageModal(context),
          //         child: Container(
          //           margin: EdgeInsets.all(10.0),
          //           child: ClipOval(
          //             child: Image.asset(
          //                 "${AppLocalizations.of(context)!.translate("lang")}"),
          //           ),
          //         ),
          //       ))
          // ],
        ),
        body: Container(
          color: Colors.green,
          margin: const EdgeInsets.symmetric(
            horizontal: 0,
          ),
          child: ListView(
            children: [
              logoHolder(),
              const SizedBox(
                height: 25,
              ),
              isLogin!
                  ? Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0))),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "login".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              textScaleFactor: 2,
                            ),
                            const SizedBox(height: 20),
                            const LoginForm(),
                            const SizedBox(height: 4),
                            Center(
                              child: TextButton(
                                  onPressed: () =>
                                      Get.to(() => ForgetPasswordForm()),
                                  child: Text(
                                    "forgotPassword".tr,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLogin = false;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${'newUser'.tr}?"),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "register".tr,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    )
                  : Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0))),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "register".tr,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              textScaleFactor: 2,
                            ),
                            const SizedBox(height: 20),
                            RegisterForm(),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLogin = true;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${'haveAccount'.tr}?"),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "login".tr,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
