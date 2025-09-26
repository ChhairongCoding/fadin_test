import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/auth/login/view/auth_page.dart';
import 'package:fardinexpress/features/banner/view/home_banner.dart';
// import 'package:fardinexpress/features/category/view/category_wrapper.dart';
import 'package:fardinexpress/features/category/view/home_category.dart';
import 'package:fardinexpress/features/home/scan_product_qrcode_page.dart';
import 'package:fardinexpress/features/home/widget/express_home_menu.dart';
import 'package:fardinexpress/features/home_activities/view/home_activity.dart';
// import 'package:fardinexpress/features/message_center/view/message_center.dart';
import 'package:fardinexpress/features/product/view/product_res_from_search_image.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail.dart';
// import 'package:fardinexpress/features/sample/controllers/categories/categories_controller.dart';
import 'package:fardinexpress/features/search/view/search_all_product.dart';
import 'package:fardinexpress/features/shop/controller/store_controller.dart';
import 'package:fardinexpress/shared/bloc/file_pickup/index.dart';
// import 'package:fardinexpress/utils/component/widget/dialog_message_widget.dart';
import 'package:fardinexpress/utils/helper/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<Uri>? _linkSubscription;
  FilePickupBloc? _filePickupBloc;

  Future<void> initDeepLinks() async {
    final appLinks = AppLinks();

    // Handle initial link
    // final initialUri = await appLinks.getInitialUri();
    // if (initialUri != null) {
    //   handleLink(initialUri);
    // }

    // Handle subsequent links
    _linkSubscription = appLinks.uriLinkStream.listen((uri) {
      print("URI LINK STREAM: ${uri}");
      handleLink(uri);
    });
  }

  void handleLink(Uri uri) {
    if ((uri.host == 'fardinexpress.asia' ||
            uri.host == 'www.fardinexpress.asia') &&
        uri.path.startsWith('/product')) {
      // Declare variables
      String? store;
      String? productId;
      String? countryCode;

      // Extract data from URL
      final pathSegments =
          uri.pathSegments; // ['product', 'amazon', 'B00LH3DMUO']
      if (pathSegments.length >= 3) {
        store = pathSegments[1]; // 'amazon'
        productId = pathSegments[2]; // 'B00LH3DMUO'
      }
      countryCode = uri.queryParameters['country'] ?? 'Unknown'; // 'IT'

      // Use variables (e.g., pass to a route)
      if (store != null && productId != null) {
        print("Can go..");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailPageWrapper(
                      id: productId!.toString(),
                      storeId: store!.toString(),
                      countryCode: countryCode!.toString(),
                    )));
        // _navigatorKey.currentState?.pushNamed(
        //   '/productDetail',
        //   arguments: {
        //     'store': store,
        //     'productId': productId,
        //     'countryCode': countryCode,
        //   },
        // );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDeepLinks();
    _filePickupBloc = FilePickupBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      // appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildBody(_) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.green,
          flexibleSpace: _buildAppBar(context), // your custom app bar widget
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green,
                  Colors.white,
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 15.0),
                ExpressHomeMenu(),
                SizedBox(height: 20.0),
                HomeBanner(),
                SizedBox(height: 20.0),
                HomeCategory(
                  pFromc: PFromC.homeCategory,
                  catId: '',
                ),
                SizedBox(height: 15.0),
                HomeActivity(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildAppBar(_) {
    // CategoryController categoryControl = Get.find(tag: "homeCategoryCtr");
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        // color: Colors.red,
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            if (BlocProvider.of<AuthenticationBloc>(context).state
                is Authenticated) {
              showSearch(
                  context: _,
                  delegate: SearchAllProduct(
                      store: Get.find<StoreController>(tag: 'initHomeStoreCtr')
                          .storeId
                          .value
                          .toString(),
                      countryCode:
                          Get.find<StoreController>(tag: 'initHomeStoreCtr')
                              .country
                              .value
                              .toString()));
              // 'CN',
              // if (controller.status.toLowerCase() == "pending" &&
              //     Get.find<TaxiController>().taxiRiddingList.length !=
              //         0) {
              //   print("check status1: " +
              //       controller.status.toLowerCase());
              //   Get.to(() => TaxiWrapperPage());
              // } else {
              //   print("check status2: " +
              //       controller.status.toLowerCase());
              //   // Get.to(() => TaxiBookingPage());
              //   Get.to(() => MapPickerScreen());
              // }
            } else {
              Get.to(() => AuthPage(
                    isLogin: true,
                  ));
            }
          },
          style: TextButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.grey[200],
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(18)),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "search".tr,
                    style: TextStyle(color: Colors.grey[700]),
                    textScaleFactor: 1,
                  ),
                ],
              ),
              // Icon(
              //   CupertinoIcons.camera_fill,
              //   color: Colors.grey[700],
              // ),
            ],
          ),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.green),
      actions: [
        // Search Product by image
        BlocListener(
          bloc: _filePickupBloc,
          listener: (context, state) {
            if (state != null) {
              // print("check image: " + state.toString());
              EasyLoading.show(
                  status: 'Searching...',
                  indicator: Icon(Icons.search),
                  maskType: EasyLoadingMaskType.black);
              Future.delayed(Duration(seconds: 2), () {
                EasyLoading.dismiss();
                Get.to(() => ProductResFromSearchImage(
                      imageUrl: state as File,
                      storeId:
                          Get.find<StoreController>(tag: 'initHomeStoreCtr')
                              .storeId
                              .value
                              .toString(),
                      // 'taobao',
                      countryCode:
                          Get.find<StoreController>(tag: 'initHomeStoreCtr')
                              .country
                              .value
                              .toString(),
                      // 'CN',
                    ));
              });
            }
          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: IconButton(
                onPressed: () {
                  _showPicker(context);
                  // DialogMessageWidget.show(
                  //   context: context,
                  //   title: 'title',
                  //   message: 'message',
                  //   success: 3,
                  //   onOk: () {},
                  // );
                },
                icon: Icon(
                  CupertinoIcons.camera_fill,
                  color: Colors.grey[700],
                )),
          ),
        ),
        //scan qr code to search product
        Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          child: IconButton(
              onPressed: () {
                if (BlocProvider.of<AuthenticationBloc>(context).state
                    is Authenticated) {
                  Get.to(() => ScanProductQrcodePage());
                  // if (controller.status.toLowerCase() == "pending" &&
                  //     Get.find<TaxiController>().taxiRiddingList.length !=
                  //         0) {
                  //   print("check status1: " +
                  //       controller.status.toLowerCase());
                  //   Get.to(() => TaxiWrapperPage());
                  // } else {
                  //   print("check status2: " +
                  //       controller.status.toLowerCase());
                  //   // Get.to(() => TaxiBookingPage());
                  //   Get.to(() => MapPickerScreen());
                  // }
                } else {
                  Get.to(() => AuthPage(
                        isLogin: true,
                      ));
                }
              },
              icon: Image.asset(
                "assets/icon/qr-code-scan.png",
                width: 25,
              )),
        ),
        // Container(
        //   margin: EdgeInsets.only(right: 10),
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: Colors.grey[200],
        //   ),
        //   child: IconButton(
        //       onPressed: () {
        //         Get.to(() => MessageCenterPage());
        //         // Get.to(() => CategoryWrapper());
        //       },
        //       icon: Icon(
        //         Icons.notifications_active,
        //         color: Theme.of(_).primaryColor,
        //       )),
        // ),
      ],
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              height: 150.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library_outlined,
                        color: Colors.blue,
                      ),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Helper.imgFromGallery((image) {
                          _filePickupBloc!.add(image);
                        });
                        // print("check image: " +
                        //     _filePickupBloc!.state.toString());
                        Navigator.of(context).pop();
                      }),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 0.5,
                      )),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera, color: Colors.red),
                    title: new Text(
                      'Camera',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Helper.imgFromCamera((image) {
                        _filePickupBloc!.add(image);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _linkSubscription?.cancel();
    super.dispose();
  }
}
