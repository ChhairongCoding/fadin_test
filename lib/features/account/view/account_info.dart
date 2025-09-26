import 'package:anakut_wallet/anakut_wallet.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/account/view/edit_account.dart';
import 'package:fardinexpress/features/address/view/address_list.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_event.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/language/view/language_modal.dart';
import 'package:fardinexpress/features/message_center/view/message_center.dart';
import 'package:fardinexpress/features/messager/screen/all_chat_page.dart';
import 'package:fardinexpress/features/messager/screen/message_center_wrapper.dart';
import 'package:fardinexpress/features/messager/screen/messager_page.dart';
import 'package:fardinexpress/features/my_order/view/my_order_page.dart';
import 'package:fardinexpress/features/taxi/view/taxi_history.dart';
import 'package:fardinexpress/features/wallet/view/wallet_page.dart';
import 'package:fardinexpress/shared/widget/pending_widget.dart';
import 'package:fardinexpress/utils/component/widget/login_button.dart';
import 'package:fardinexpress/utils/component/widget/register_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final AccountController _controller = Get.find<AccountController>();

  Future<void> _exitApp() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert !'),
            content: Text("${'aUSureToLogOut'.tr}?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // print("you choose no");
                  Navigator.of(context).pop(false);
                },
                child: const Text('No', style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () async {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(UserLoggedOut());
                  await Future.delayed(Duration(milliseconds: 500));
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        // appBar: AppBar(),
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
                    SizedBox(
                      height:
                          MediaQuery.of(context).padding.top + kToolbarHeight,
                    ),
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
            return SingleChildScrollView(
              // color: Colors.grey[200],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    if (_controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade700,
                              Colors.green.shade300,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        // color: Colors.green,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: Container(
                          width: double.infinity,
                          // margin: const EdgeInsets.only(
                          //     left: 6.0, right: 6.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            // border: Border.all(width: 0.7, color: Colors.white70),
                            // color: Colors.orange[400],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0),
                                        // padding: const EdgeInsets.all(25.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.white)),
                                        child: Container(
                                          child: CircleAvatar(
                                            radius: 30.0,
                                            child: ClipOval(
                                                child: _controller
                                                                .image.value ==
                                                            "" ||
                                                        _controller.image.value
                                                                .toString() ==
                                                            "null"
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 0.0),
                                                        child: Text(
                                                          _controller.accountInfo
                                                                      .id ==
                                                                  '0'
                                                              ? ""
                                                              : _controller
                                                                  .userName
                                                                  .value
                                                                  .substring(
                                                                      0, 1),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green[300],
                                                              fontSize: 30.0),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero, // Remove default padding
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent, // Optional: Transparent background
                                                                content:
                                                                    Container(
                                                                  width: 300,
                                                                  height: 300,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image:
                                                                        DecorationImage(
                                                                      image: NetworkImage(_controller
                                                                          .image
                                                                          .value),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: ExtendedImage
                                                            .network(
                                                          _controller
                                                              .image.value,
                                                          // errorWidget: Image.asset(
                                                          //     "assets/img/fardin-logo.png"),
                                                          cacheWidth: 150,
                                                          cacheHeight: 150,
                                                          // enableMemoryCache: true,
                                                          clearMemoryCacheWhenDispose:
                                                              true,
                                                          clearMemoryCacheIfFailed:
                                                              false,
                                                          fit: BoxFit.fill,
                                                          // width: double.infinity,
                                                          // height: double.infinity,
                                                        ),
                                                      )),
                                            backgroundColor: Colors.grey[200],
                                          ),
                                        )),
                                  ),
                                  Container(
                                    // color: Colors.red,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 0.0),
                                          decoration: BoxDecoration(
                                              // border: Border.all(
                                              //     color: const Color.fromARGB(
                                              //         255, 34, 253, 41),
                                              //     width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              color: Colors.transparent),
                                          child: Text(
                                              _controller.userName.value,
                                              textScaler:
                                                  TextScaler.linear(1.5),
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                        SizedBox(height: 0.0),
                                        Text(
                                          "${_controller.accountInfo.phone}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: () => Get.to(() => EditAccount()),
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 20.0),
                                  decoration: BoxDecoration(
                                      // border: Border.all(
                                      //     color: const Color.fromARGB(
                                      //         255, 34, 253, 41),
                                      //     width: 1.0),
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Colors.blue),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.manage_accounts_outlined,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "  ${'manageAccount'.tr}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 18.0),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                  // Container(
                  //   height: 30,
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [
                  //         Colors.green.shade700,
                  //         Colors.green.shade300,
                  //       ],
                  //       begin: Alignment.topLeft,
                  //       end: Alignment.bottomRight,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context).primaryColor),
                      child: Icon(
                        Icons.map_outlined,
                        color: Colors.white,
                      ),
                    ),
                    title: Text("address".tr),
                    subtitle: Text(
                      "allAddressHere".tr,
                      style: TextStyle(color: Colors.black54),
                    ),
                    trailing: Container(
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 30.0,
                      ),
                    ),
                    onTap: () => Get.to(() => AddressList(
                          isCheckout: false,
                        )),
                  ),
                  ListTile(
                    onTap: () => Get.to(() => MyOrderPage(initIndex: 0)),
                    leading: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context).primaryColor),
                      child: Icon(Icons.my_library_books_outlined,
                          color: Colors.white),
                    ),
                    title: Text("myOrder".tr),
                    subtitle: Text("allOrderHere".tr,
                        style: TextStyle(color: Colors.black54)),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30.0,
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context).primaryColor),
                      child:
                          Icon(Icons.share_location_sharp, color: Colors.white),
                    ),
                    title: Text("taxiBookingHistory".tr),
                    subtitle: Text("allSaveWishlist".tr,
                        style: TextStyle(color: Colors.black54)),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30.0,
                    ),
                    onTap: () => Get.to(() => TaxiHistoryScreen()),
                  ),
                  PendingWidget(
                    firstChild: SizedBox.shrink(),
                    secondChild: ListTile(
                      onTap: () => Get.to(() => AnakutWallet(
                            phone: _controller.accountInfo.phone,
                            firstName: '${_controller.accountInfo.name}',
                            lastName: '',
                          )),
                      // onTap: () => Get.to(() =>
                      // WalletPage(title: "wallet".tr)
                      // ),
                      leading: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Theme.of(context).primaryColor),
                        child: Icon(Icons.account_balance_wallet_outlined,
                            color: Colors.white),
                      ),
                      title: Text("wallet".tr),
                      subtitle: Text("${'topUp'.tr}, ${'transaction'.tr}"),
                    ),
                  ),
                  ListTile(
                    onTap: () => languageModal(context),
                    leading: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context).primaryColor),
                      child:
                          Icon(Icons.g_translate_rounded, color: Colors.white),
                    ),
                    title: Text("language".tr),
                    subtitle: Text("ខ្មែរ, English",
                        style: TextStyle(color: Colors.black54)),
                  ),
                  ListTile(
                    // onTap: () => Get.to(() => MessageCenterPage()),-
                    // onTap: () => Get.to(() => ChatListScreen()),
                    onTap: () => Get.to(() => MessageCenterWrapper()),
                    leading: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context).primaryColor),
                      child: Icon(CupertinoIcons.chat_bubble_2,
                          color: Colors.white),
                    ),
                    title: Text("notification".tr),
                    subtitle: Text("Message Center",
                        style: TextStyle(color: Colors.black54)),
                  ),
                  ListTile(
                    // onTap: () => Get.to(() => SuccessfulScreen(successScreenType: SuccessScreenType.otherType,)),
                    leading: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context).primaryColor),
                      child: Icon(Icons.system_update_rounded,
                          color: Colors.white),
                    ),
                    title: Text("version".tr),
                    subtitle:
                        Text("1.0.3", style: TextStyle(color: Colors.black54)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _exitApp();
                    },
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Theme.of(context).primaryColor),
                        child: Icon(Icons.logout, color: Colors.white),
                      ),
                      title: Text("logOut".tr,
                          style: TextStyle(color: Colors.redAccent)),
                      // onTap: (){},
                    ),
                  ),
                ],
              ),
            );
          }
        }));
  }
}

class PatternBackground extends StatelessWidget {
  const PatternBackground({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: DiagonalPatternPainter(),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green, // Base green background
          ),
          child: const Center(
            child: Text(
              'Pattern Background',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}

class DiagonalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2;

    const spacing = 30.0;

    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
