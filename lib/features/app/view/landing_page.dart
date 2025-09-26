import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/cart/controller/cart_store_controller.dart';
import 'package:fardinexpress/features/home/home.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/taxi/controller/taxi_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthState>(listener: (c, state) {
        if (state is Authenticated) {
          // print("This is my // ${state.accessToken}");
          // Get.find<AccountController>();
          Get.find<AccountController>().context = context;
          Get.find<CartStoreController>();
          Get.find<TaxiController>().initTaxiRidding('taxi');
          Get.find<ProductController>();
          // Get.put(() => CartStoreController().getCartStoreList(),
          //     tag: "cartStoreCtr");
          // initNotification(state.accessToken!.toString());
          // BlocProvider.of<P  rofileBloc>(context).add(GetProfileStarted());
          // HomeBodyState.isSelected = true;
        }
      }, builder: (context, state) {
        if (state is AuthenticationInitialize) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Home();
        }
      }),
    );
  }
}
