import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/auth/login/view/auth_page.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shimmer/shimmer.dart';

class ProductResFromSearchImage extends StatefulWidget {
  final File imageUrl;
  final String storeId;
  final String countryCode;
  const ProductResFromSearchImage(
      {Key? key,
      required this.imageUrl,
      required this.storeId,
      required this.countryCode})
      : super(key: key);

  @override
  State<ProductResFromSearchImage> createState() =>
      ProductResFromSearchImageState();
}

class ProductResFromSearchImageState extends State<ProductResFromSearchImage> {
  final ProductController? productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    // productController = Get.put(ProductController());
    productController!
        .searchProductByImage(image: widget.imageUrl, storeId: widget.storeId);
    // productController!
    //     .initProductByImageSearch(widget.imageUrl, widget.storeId);
    // productController!
    //     .paginateProFromSearchImg(widget.imageUrl, widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Search Result",
          style: TextStyle(color: Colors.black),
        )),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Icon(CupertinoIcons.arrow_right_circle)),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Obx(() {
                      if (productController!.imageUrl == "") {
                        return Container();
                      } else {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              "${productController!.imageUrl.value}",
                              height: 70,
                            ));
                      }
                    }),
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  if (productController!.isDataProcessing.value == true &&
                      productController!.productListSearch.isEmpty) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(), // Enables scrolling
                        shrinkWrap:
                            false, // Allows it to expand based on content
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 4 / 5.5,
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        // itemCount: 6,
                        controller: productController!
                            .scrollController, // Pagination controller
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: GestureDetector(
                              onTap: () {},
                              // => Get.to(() => ProductDetailPageWrapper(
                              //       name: productController!.productList[index].name!,
                              //       price: productController!.productList[index].price!,
                              //       image: productController!.productList[index].image,
                              //       description: productController!.productList[index].name!,
                              //       promotionPrice:
                              //           productController!.productList[index].price!,
                              //       id: productController!.productList[index].id!,
                              //       storeId: widget.storeId.toString(),
                              //       descriptionDetail:
                              //           productController!.productList[index].description,
                              //     )),
                              child: AspectRatio(
                                aspectRatio: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                topRight: Radius.circular(8.0),
                                              ),
                                              color: Colors.grey[350],
                                            ),
                                            margin: EdgeInsets.all(6.0),
                                            child: Container(
                                              width: 400,
                                              height: 400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text(
                                                "",
                                                textScaleFactor: 1.2,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(),
                                            Text(
                                              "",
                                              maxLines: 1,
                                              textScaleFactor: 1.1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (productController!.productListSearch.isNotEmpty &&
                      productController!.isDataProcessing.value == false) {
                    return Container(
                      // color: Colors.red,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 10),
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(), // Enables scrolling
                          shrinkWrap:
                              false, // Allows it to expand based on content
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 4 / 5.5,
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount:
                              productController!.productListSearch.length,
                          controller: productController!
                              .scrollController, // Pagination controller
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (BlocProvider.of<AuthenticationBloc>(context)
                                    .state is Authenticated) {
                                  Get.to(() => ProductDetailPageWrapper(
                                        id: productController!
                                            .productListSearch[index].id!,
                                        storeId: widget.storeId.toString(),
                                        countryCode:
                                            widget.countryCode.toString(),
                                      ));
                                  // final result = Get.to(() =>
                                  //     ProductDetailPageWrapper(
                                  //       id: productController!.productList[index].id!,
                                  //       storeId:
                                  //           storeController.storeId.value.toString(),
                                  //       countryCode:
                                  //           storeController.country.value.toString(),
                                  //     ));
                                  // if (result == true) {
                                  //   storeController.isRefresh.value = false;
                                  // }
                                } else {
                                  Get.to(() => AuthPage(
                                        isLogin: true,
                                      ));
                                }
                              },
                              child: AspectRatio(
                                aspectRatio: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0),
                                                ),
                                                color: Colors.grey[350],
                                              ),
                                              margin: EdgeInsets.all(6.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height:
                                                      250, // Adjust height based on your layout
                                                  child: ExtendedImage.network(
                                                    productController!
                                                            .productListSearch[
                                                                index]
                                                            .image
                                                            .startsWith("http")
                                                        ? productController!
                                                            .productListSearch[
                                                                index]
                                                            .image
                                                        : "http:${productController!.productListSearch[index].image}",
                                                    fit: BoxFit
                                                        .cover, // Use BoxFit.cover to maintain aspect ratio while covering the container
                                                    cacheWidth:
                                                        600, // Adjust cache size based on how sharp you want it
                                                    cacheHeight: 400,
                                                    clearMemoryCacheWhenDispose:
                                                        true,
                                                    clearMemoryCacheIfFailed:
                                                        false,
                                                    loadStateChanged:
                                                        (ExtendedImageState
                                                            state) {
                                                      switch (state
                                                          .extendedImageLoadState) {
                                                        case LoadState.loading:
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        case LoadState.failed:
                                                          return Center(
                                                              child: Icon(
                                                                  Icons
                                                                      .error_outline,
                                                                  color: Colors
                                                                      .red));
                                                        case LoadState
                                                            .completed:
                                                          return null; // default render
                                                      }
                                                    },
                                                  ),
                                                ),
                                              )

                                              // ExtendedImage.network(
                                              //   productController!
                                              //           .productList[index].image
                                              //           .contains("https:")
                                              //       ? productController!
                                              //           .productList[index].image
                                              //       : "https:" +
                                              //           productController!
                                              //               .productList[index].image,
                                              //   // "https:" +
                                              //   //     productController!
                                              //   //         .productList[index].image,
                                              //   cacheWidth: 400,
                                              //   cacheHeight: 400,
                                              //   // enableMemoryCache: true,
                                              //   clearMemoryCacheWhenDispose: true,
                                              //   clearMemoryCacheIfFailed: false,
                                              //   fit: BoxFit.cover,
                                              //   width: double.infinity,
                                              // ),
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text(
                                                productController!
                                                    .productListSearch[index]
                                                    .name!,
                                                textScaleFactor: 1.2,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(),
                                            Text(
                                              "${productController!.productListSearch[index].price!} \$",
                                              maxLines: 1,
                                              textScaleFactor: 1.1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  // if (productController!!.productList == [] &&
                  //     productController!!.isDataProcessing.value == false &&
                  //     productController!!.isMoreDataAvailable.value == false) {
                  //   return Center(
                  //     child: Text("No products found!"),
                  //   );
                  //   // color: Colors.red,
                  // }
                  else {
                    return Center(
                      child: Text("No products found!"),
                    );
                  }
                }),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // storeController.storeId.value = "taobao";
    // storeController.country.value = "china";
    // storeController.selectedStore.value = 0;
    // Delete the controller from memory
    // if (Get.isRegistered<ProductController>()) {
    //   Get.delete<ProductController>();
    // }
    super.dispose();
  }
}
