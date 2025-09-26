import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/express/view/delivery_history_page.dart';
import 'package:fardinexpress/utils/component/widget/login_button.dart';
import 'package:fardinexpress/utils/component/widget/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryHistoryWrapper extends StatefulWidget {
  final String transportType;
  const DeliveryHistoryWrapper({Key? key, required this.transportType})
      : super(key: key);

  @override
  State<DeliveryHistoryWrapper> createState() => _DeliveryHistoryWrapperState();
}

class _DeliveryHistoryWrapperState extends State<DeliveryHistoryWrapper> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: BlocBuilder<AuthenticationBloc, AuthState>(
            builder: (context, state) {
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
            return DeliveryHistoryPage(
                initIndex: 0, transportType: widget.transportType);
          }
        }),
      ),
      onWillPop: () async {
        if (widget.transportType == "express") {
          return true;
        } else {
          return false;
        }
      },
    );
  }
}
