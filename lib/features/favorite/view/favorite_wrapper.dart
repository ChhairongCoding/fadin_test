import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/favorite/view/favorite_list.dart';
import 'package:fardinexpress/utils/component/widget/login_button.dart';
import 'package:fardinexpress/utils/component/widget/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class FavoriteWrapper extends StatelessWidget {
  const FavoriteWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("wishlist".tr),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          BlocBuilder<AuthenticationBloc, AuthState>(builder: (context, state) {
        if (state is NotAuthenticated) {
          return Container(
            // color: Colors.yellow,
            // width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loginButton(context: context),
                const SizedBox(height: 15),
                registerButton(context: context),
              ],
            ),
          );
        } else {
          return FavoriteList();
        }
      }),
    );
  }
}
