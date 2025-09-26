import 'dart:async';

// import 'package:app_links/app_links.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/account/view/account_info.dart';
import 'package:fardinexpress/features/cart/view/cart_page.dart';
import 'package:fardinexpress/features/category/controller/category_controller.dart';
import 'package:fardinexpress/features/category/view/category_wrapper.dart';
// import 'package:fardinexpress/features/favorite/view/favorite_wrapper.dart';
import 'package:fardinexpress/features/home/home_page.dart';
import 'package:fardinexpress/features/home/widget/bottom_navigation_bar.dart';
// import 'package:fardinexpress/features/product/view/product_by_all_category.dart';
import 'package:fardinexpress/features/shop/controller/store_controller.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
import 'package:fardinexpress/utils/bloc/invoking/invoking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

IndexingBloc? bottomNavigationIndexBloc;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  static List<InvokingBloc>? bottomNavigationPagesInvokingBloc;
  final StoreController _storeController =
      Get.put(StoreController(), tag: "initHomeStoreCtr");
  final CategoryController _categoryController =
      Get.put(CategoryController(), tag: "homeActivityCtr");

  // final _navigatorKey = GlobalKey<NavigatorState>();
  // StreamSubscription<Uri>? _linkSubscription;

  final List<Widget> bottomNavigationPages = [
    const HomePage(),
    const CategoryWrapper(),
    const CartPage(),
    const AccountInfo(),
    // const FavoriteWrapper(),
  ];

  // Future<void> initDeepLinks() async {
  //   final appLinks = AppLinks();

  //   // Handle initial link
  //   // final initialUri = await appLinks.getInitialUri();
  //   // if (initialUri != null) {
  //   //   handleLink(initialUri);
  //   // }

  //   // Handle subsequent links
  //   _linkSubscription = appLinks.uriLinkStream.listen((uri) {
  //     handleLink(uri);
  //   });
  // }

  // void handleLink(Uri uri) {
  //   if (uri.host == 'fardinexpress.asia' && uri.path.startsWith('/product')) {
  //     // Declare variables
  //     String? store;
  //     String? productId;
  //     String? countryCode;

  //     // Extract data from URL
  //     final pathSegments =
  //         uri.pathSegments; // ['product', 'amazon', 'B00LH3DMUO']
  //     if (pathSegments.length >= 3) {
  //       store = pathSegments[1]; // 'amazon'
  //       productId = pathSegments[2]; // 'B00LH3DMUO'
  //     }
  //     countryCode = uri.queryParameters['country'] ?? 'Unknown'; // 'IT'

  //     // Use variables (e.g., pass to a route)
  //     if (store != null && productId != null) {
  //       _navigatorKey.currentState?.pushNamed(
  //         '/productDetail',
  //         arguments: {
  //           'store': store,
  //           'productId': productId,
  //           'countryCode': countryCode,
  //         },
  //       );
  //     }
  //   }
  // }

  void openAppLink(Uri uri) {
    // _navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  @override
  void initState() {
    super.initState();
    // initDeepLinks();
    bottomNavigationIndexBloc = IndexingBloc();
    bottomNavigationPagesInvokingBloc = [
      InvokingBloc(),
      InvokingBloc(),
      InvokingBloc(),
      InvokingBloc(),
      // InvokingBloc(),
    ];
    _storeController.getStoreList(getStoreType: 'store_home');
  }

  void _showStoreSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Adjust height as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Select a store",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              Expanded(child: Obx(() {
                if (_storeController.isLoading.value) {
                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildStoreOption(
                        context,
                        Colors.white,
                        Colors.white,
                        "",
                        "",
                        Container(),
                        Colors.grey[300]!,
                        Colors.green,
                        0.8,
                        "assets/extend_assets/icons/usa-style.png",
                      ),
                      _buildStoreOption(
                        context,
                        Colors.white,
                        Colors.white,
                        "",
                        "",
                        Container(),
                        Colors.grey[300]!,
                        Colors.transparent,
                        0.8,
                        "assets/extend_assets/icons/chinese-style.png",
                      ),
                      _buildStoreOption(
                        context,
                        Colors.white,
                        Colors.white,
                        "",
                        "",
                        Container(),
                        Colors.grey[300]!,
                        Colors.transparent,
                        0.8,
                        "assets/extend_assets/icons/thailand-style.png",
                      ),
                    ],
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView.builder(
                        itemCount: _storeController.storeList.length,
                        itemBuilder: (context, index) {
                          bool isSelected =
                              index == _storeController.selectedStore.value;
                          return _buildStoreOption(
                            context,
                            isSelected ? Colors.white : Colors.black,
                            isSelected ? Colors.white70 : Colors.grey[700]!,
                            _storeController.storeList[index].name.toString(),
                            "The Best of the ${_storeController.storeList[index].name.toString()} in One Place!"
                                .toString(),
                            isSelected
                                ? Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  )
                                : Container(),
                            isSelected
                                ? Colors.black.withOpacity(0.5)
                                : Colors.white,
                            Colors.green,
                            isSelected ? 0.3 : 1.0,
                            "${_storeController.storeList[index].image}",
                            onTap: () {
                              _storeController.storeId.value = _storeController
                                  .storeList[index].id
                                  .toString();
                              _storeController.country.value = _storeController
                                  .storeList[index].country
                                  .toString();
                              _storeController.selectedStore.value = index;
                              _categoryController.categories.clear();
                              _categoryController.getCategories();
                              Get.back();
                              EasyLoading.show(
                                  status: 'Loading...',
                                  maskType: EasyLoadingMaskType.black,
                                  dismissOnTap: false);
                              Future.delayed(Duration(seconds: 3), () {
                                EasyLoading.dismiss();
                              });
                            },
                          );
                        }),
                  );
                }
              })),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
          bloc: bottomNavigationIndexBloc,
          builder: (BuildContext context, dynamic state) {
            return IndexedStack(
              index: state,
              children: bottomNavigationPages,
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(2.0),
          child: Obx(() {
            if (_storeController.isLoading.value) {
              return Container();
            } else {
              return ClipOval(
                child: Transform.scale(
                  scale: 1.6, // Increase this value if needed
                  child: Image.network(
                    "${_storeController.storeList[_storeController.selectedStore.value].image}",
                    fit: BoxFit.cover,
                  ),
                ),
              );
              // ClipOval(
              //   child: Image.network(
              //     "${_storeController.storeList[_storeController.selectedStore.value].image}",
              //     width: double.infinity, // Ensures it covers the entire button
              //     height: double.infinity,
              //     fit: BoxFit.cover, // Ensures full coverage
              //   ),
              // );
              // ExtendedImage.network(
              //   "${_storeController.storeList[_storeController.selectedStore.value].image}",
              //   cacheWidth: 50,
              //   enableMemoryCache: true,
              //   fit: BoxFit.contain,
              //   // shape: BoxShape.circle,
              //   clearMemoryCacheWhenDispose: true,
              // );
            }
          }),

          // Image.asset(
          //   "assets/img/fardin-logo.png",
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
        ),
        // Icon(
        //   Icons.shopping_cart,
        //   color: Colors.white,
        // ),
        onPressed: () {
          // Get.to(() => CartPage());
          _showStoreSelector(context);
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildStoreOption(
    BuildContext context,
    Color titleColor,
    Color descriptionColor,
    String title,
    String description,
    Widget icon,
    Color backgroundColor,
    Color iconColor,
    double opacity,
    String image, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        elevation: 1,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Image overlay
              Positioned(
                bottom: 10,
                right: 10,
                child: Opacity(
                  opacity: opacity, // Adjust overlay transparency
                  child: ExtendedImage.network(
                    "${image}",
                    // color: Colors.yellow,
                    // cacheWidth: 100,
                    width: 100,
                    // enableMemoryCache: true,
                    fit: BoxFit.contain,
                    // shape: BoxShape.circle,
                    clearMemoryCacheWhenDispose: true,
                  ),
                ),
              ),
              // Circular center overlay
              icon,
              // Text content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: descriptionColor,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "Explore Store",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          color: titleColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildStoreOption(
  //   BuildContext context,
  //   String title,
  //   String description,
  //   IconData icon,
  //   Color backgroundColor,
  //   Color iconColor,
  //   String image,
  // ) {
  //   return Card(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       color: backgroundColor,
  //       elevation: 0,
  //       child: Container(
  //         child: Stack(
  //           children: [
  //             Positioned(
  //               bottom: 16,
  //               right: 16,
  //               child: Image.asset(
  //                 "${image}",
  //                 width: 150.0,
  //                 height: 150.0,
  //               ),
  //             ),
  //             Container(
  //               padding: EdgeInsets.all(16),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     title,
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                   Text(
  //                     description,
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.grey[700],
  //                         fontSize: 12),
  //                   ),
  //                   SizedBox(height: 50),
  //                   Row(
  //                     children: [
  //                       Text(
  //                         "Explore Store",
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold, fontSize: 12),
  //                       ),
  //                       SizedBox(width: 10),
  //                       Icon(Icons.arrow_forward)
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       )
  //       // ListTile(
  //       //   title: Text(
  //       //     title,
  //       //     style: TextStyle(fontWeight: FontWeight.bold),
  //       //   ),
  //       //   subtitle: Text(description),
  //       //   trailing: Icon(icon, color: iconColor),
  //       //   onTap: () {
  //       //     Navigator.pop(context);
  //       //     // ScaffoldMessenger.of(context).showSnackBar(
  //       //     //   SnackBar(content: Text('$title selected')),
  //       //     // );
  //       //   },
  //       // ),
  //       );
  // }

  @override
  void dispose() {
    bottomNavigationIndexBloc!.close();
    for (var bloc in bottomNavigationPagesInvokingBloc!) {
      bloc.close();
    }
    // _linkSubscription?.cancel();
    super.dispose();
  }
}
