import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/sample/pages/cart.dart';
import 'package:fardinexpress/utils/component/widget/login_button.dart';
import 'package:fardinexpress/utils/component/widget/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("cart".tr),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<AuthenticationBloc, AuthState>(
            builder: (context, state) {
          if (state is NotAuthenticated) {
            return Center(
              // color: Colors.yellow,
              // width: double.infinity,
              // margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 20.0),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.asset(
                          "assets/illustration/required-authentication.png",
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    Text('${'sign in to explore more'.tr} !'),
                    const SizedBox(height: 20),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: loginButton(context: context)),
                        const SizedBox(width: 15),
                        Expanded(child: registerButton(context: context)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CartItem();
          }
        }));
  }
}
