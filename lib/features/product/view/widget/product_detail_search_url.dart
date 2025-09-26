import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/image_slider.dart';
import 'package:fardinexpress/features/cart/controller/add_to_cart_controller.dart';
import 'package:fardinexpress/features/cart/controller/cart_store_controller.dart';
import 'package:fardinexpress/features/cart/view/cart_page.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:fardinexpress/features/product/view/widget/btn_add_to_cart.dart';
import 'package:fardinexpress/features/product/view/widget/btn_buy_now.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_state.dart';
import '../../../auth/login/view/auth_page.dart';

class ProductDetailSearchUrl extends StatefulWidget {
  final String webUrl;
  ProductDetailSearchUrl({required this.webUrl});

  @override
  _ProductDetailSearchUrlState createState() => _ProductDetailSearchUrlState();
}

class _ProductDetailSearchUrlState extends State<ProductDetailSearchUrl> {
  // final ProductDetailBloc productDetailBloc = ProductDetailBloc();
  // final _controller = Get.find<ProductController>();
  // final ProductController _controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<ProductController>().getProductFromURL(webUrl: widget.webUrl);
  }

  @override
  void dispose() {
    // productDetailBloc.close();
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<ProductController>(
        // tag: widget.id,
        // id: 'product_detail',
        builder: (controller) {
      if (controller.isFetching) {
        return Center(child: CircularProgressIndicator());
      }
      if (controller.productDetail == null ||
          controller.productDetail!.id == null) {
        return Center(child: Text("No item found"));
      } else {
        var item = Get.find<ProductController>().productDetail;
        return ProductDetailPage(
          name: item!.name!,
          price: item.price!,
          image: item.image![0],
          description: item.description!,
          promotionPrice: item.price!,
          id: item.id.toString(),
          storeId: item.storeCode.toString(),
          descriptionDetail: item.description!,
          // descriptionDetail: item.descriptionDetail!,
          productDetail: item,
          reqUrl: Get.find<ProductController>().reqProductDetailUrl.value,
          countryCode: item.countryCode!.toString(),
        );
      }
    }));

    //     ProductDetailPage(
    //   name: widget.name,
    //   price: widget.price,
    //   image: widget.image,
    //   description: widget.description,
    //   promotionPrice: widget.promotionPrice,
    //   id: widget.id,
    //   storeId: widget.storeId,
    //   descriptionDetail: widget.descriptionDetail,
    // ));
  }
}

class ProductDetailPage extends StatefulWidget {
  final String id;
  final String name;
  final String price;
  final String image;
  final String description;
  final String promotionPrice;
  final String storeId;
  final String descriptionDetail;
  final ProductModelRes? productDetail;
  final String reqUrl;
  final String countryCode;
  ProductDetailPage(
      {Key? key,
      required this.id,
      required this.name,
      required this.price,
      required this.image,
      required this.description,
      required this.promotionPrice,
      required this.storeId,
      required this.descriptionDetail,
      required this.productDetail,
      required this.reqUrl,
      required this.countryCode})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List taps = [
    {"name": "description"},
    {"name": "specification"}
  ];
  final ScreenshotController screenshotController = ScreenshotController();
  final AddToCartController _addToCartController =
      Get.put(AddToCartController(), tag: "addToCartCtr");
  final _cartStoreController = Get.find<CartStoreController>();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //return Test();back
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverSafeArea(
                          top: false,
                          sliver: SliverAppBar(
                            // brightness: Theme.of(context).brightness,
                            elevation: 0,
                            backgroundColor: Colors.white,
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: RawMaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  elevation: 1,
                                  fillColor: Colors.white
                                      .withAlpha((0.3 * 255).round()),
                                  child: Icon(Icons.arrow_back_rounded,
                                      color: Colors.black),
                                  shape: CircleBorder(),
                                ),
                              ),
                            ),
                            expandedHeight: width,
                            floating: false,
                            pinned: true,
                            // flexibleSpace: FlexibleSpaceBar(
                            //   background: Opacity(
                            //     opacity: 1,
                            //     child: Image.network("https:" + widget.image),
                            //   ),
                            // ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: (widget.productDetail!.image ==
                                          null ||
                                      widget.productDetail!.image!.length == 0)
                                  ? AspectRatio(
                                      aspectRatio: 2,
                                      child: Opacity(
                                        opacity: 0.2,
                                        child: Image.asset(
                                          "assets/img/image-gallery.png",
                                          fit: BoxFit.contain,
                                          cacheWidth: 400,
                                        ),
                                      ),
                                    )
                                  : ImageSlider(
                                      fit: BoxFit.fitWidth,
                                      aspectRatio: 4 / 4,
                                      duration: 10000,
                                      images: widget.productDetail!.image!,
                                      // "https:" +
                                      autoPlay: false,
                                      showDot: false,
                                      willCache: false,
                                    ),
                            ),
                            actions: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    try {
                                      final image =
                                          await screenshotController.capture();
                                      if (image == null) return;

                                      final directory =
                                          await getApplicationDocumentsDirectory();
                                      final imagePath = await File(
                                              '${directory.path}/product.png')
                                          .create();
                                      await imagePath.writeAsBytes(image);

                                      final productUrl = '${widget.reqUrl}';

                                      await Share.shareXFiles(
                                        [XFile(imagePath.path)],
                                        text:
                                            'Check out this product: $productUrl',
                                      );
                                    } catch (e) {
                                      print('Error sharing screenshot: $e');
                                      Get.snackbar(
                                          'Error', 'Failed to share product');
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                            .withAlpha((0.3 * 255).round()),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(
                                                (0.1 * 255)
                                                    .round()), // Light shadow
                                            blurRadius:
                                                2, // Small blur for subtle shadow
                                            offset:
                                                Offset(0, 1), // Vertical offset
                                          ),
                                        ],
                                      ),
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: Icon(
                                        Icons.ios_share,
                                        color: Colors.blue,
                                      )),
                                ),
                              ),
                              SizedBox(width: 5),
                              AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                          .withAlpha((0.3 * 255).round()),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(
                                              (0.1 * 255)
                                                  .round()), // Light shadow
                                          blurRadius:
                                              2, // Small blur for subtle shadow
                                          offset:
                                              Offset(0, 1), // Vertical offset
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.pushNamed(context, cart,
                                  //     arguments: true);
                                },
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: badges.Badge(
                                    badgeContent: Obx(
                                      () => Text(
                                        "${_cartStoreController.cartQty.value}",
                                        // textScaleFactor: 0.6,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    position:
                                        BadgePosition.topEnd(top: 3, end: 8),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white
                                                .withAlpha((0.1 * 255).round()),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(
                                                    (0.1 * 255)
                                                        .round()), // Light shadow
                                                blurRadius:
                                                    2, // Small blur for subtle shadow
                                                offset: Offset(
                                                    0, 1), // Vertical offset
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () =>
                                                Get.to(() => CartPage()),
                                            icon: Icon(
                                              Icons.shopping_cart_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(18.0),
                        //     topRight: Radius.circular(18.0)
                        //     ),
                      ),
                      child: ProductDetailBody(
                        name: widget.name,
                        price: widget.price,
                        description: widget.description,
                        promotionPrice: widget.promotionPrice,
                        descriptionDetail: widget.descriptionDetail,
                        productModelRes: widget.productDetail!,
                        storeId: widget.storeId,
                        countryCode: widget.countryCode,
                        productId: widget.id,
                      ))),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(left: 15, bottom: 25, right: 15),
            child: Row(
              children: [
                Expanded(
                    child: Obx(() => btnAddToCart(
                        onPressed: () {
                          if (BlocProvider.of<AuthenticationBloc>(context).state
                              is Authenticated) {
                            if (_addToCartController.isLoading.value == false) {
                              _addToCartController.addProductToCart(
                                  widget.id.toString(),
                                  "1",
                                  "${widget.storeId}",
                                  "addToCart");
                            }
                          } else {
                            Get.to(() => AuthPage(
                                  isLogin: true,
                                ));
                          }
                        },
                        title: _addToCartController.isLoading.value == true
                            ? "Processing"
                            : "addToCart".tr))),
                // SizedBox(width: 15),
                Expanded(child: btnBuyNow(onPressed: () {
                  if (BlocProvider.of<AuthenticationBloc>(context).state
                      is Authenticated) {
                    if (_addToCartController.isLoading.value == false) {
                      _addToCartController.addProductToCart(
                          widget.id.toString(),
                          "1",
                          "${widget.storeId}",
                          "buynow");
                    }
                  } else {
                    Get.to(() => AuthPage(
                          isLogin: true,
                        ));
                  }
                })),
                // BtnAddToCart(
                //   product: widget.product,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
