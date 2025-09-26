import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/auth/login/view/auth_page.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail.dart';
import 'package:fardinexpress/features/shop/controller/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductSearchListGridAll extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String storeId;
  final String country;
  const ProductSearchListGridAll(
      {Key? key,
      required this.categoryId,
      required this.categoryName,
      required this.storeId,
      required this.country})
      : super(key: key);

  @override
  State<ProductSearchListGridAll> createState() =>
      ProductSearchListGridAllState();
}

class ProductSearchListGridAllState extends State<ProductSearchListGridAll>
    with AutomaticKeepAliveClientMixin {
  static ProductController? productController;
  // Get.find<ProductController>(tag: 'product_all_category');
  TextEditingController queryCtr = TextEditingController();
  final StoreController storeController =
      Get.put(StoreController(), tag: "searchProductByAllCategoryCtr");

  @override
  void initState() {
    super.initState();
    // storeController.isRefresh.value = true;
    productController = Get.put(ProductController(), permanent: true);
    if (storeController.isRefresh.value == true) {
      storeController.getStoreList(getStoreType: 'store_home');
    }
    // productController.initCategoryId.value = widget.categoryId;
    if (storeController.isRefresh.value == true) {
      productController!.initProductByStoreId(
          widget.categoryName,
          widget.categoryId,
          storeController.storeId.value.toString(),
          "render",
          "",
          storeController.country.value,
          "default");
      productController!.paginateProductListByStoreId(
          widget.categoryName,
          widget.categoryId,
          storeController.storeId.value.toString(),
          "render",
          "",
          storeController.country.value,
          "default");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: Obx(() {
          if (storeController.isLoading.value) {
            if (storeController.backupStoreList.isEmpty) {
              return Container();
            } else {
              return SizedBox(
                height: 40, // Fixed height for the horizontal store list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: storeController.backupStoreList.length,
                  itemBuilder: (context, index) {
                    // bool isSelected =
                    //     index == storeController.selectedStore.value;
                    return GestureDetector(
                      onTap: () async {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.0),
                          // border: Border.all(
                          //   color: Colors.grey,
                          //   width: 1.0,
                          // ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ExtendedImage.network(
                          "${storeController.backupStoreList[index].image}",
                          // cacheWidth: 200,
                          // width: 200,
                          // enableMemoryCache: true,
                          fit: BoxFit.cover,
                          clearMemoryCacheWhenDispose: true,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            return SizedBox(
              height: 40, // Fixed height for the horizontal store list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: storeController.storeList.length,
                itemBuilder: (context, index) {
                  bool isSelected =
                      index == storeController.selectedStore.value;
                  return GestureDetector(
                    onTap: () async {
                      storeController.storeId.value =
                          await storeController.storeList[index].id.toString();
                      storeController.country.value = await storeController
                          .storeList[index].country
                          .toString();
                      storeController.selectedStore.value = index;
                      storeController.getStoreList(getStoreType: 'store_list');
                      productController!.initProductByStoreId(
                          widget.categoryName,
                          widget.categoryId,
                          storeController.storeId.value.toString(),
                          "render",
                          "",
                          storeController.country.value,
                          "default");
                      productController!.paginateProductListByStoreId(
                          widget.categoryName,
                          widget.categoryId,
                          storeController.storeId.value.toString(),
                          "render",
                          "",
                          storeController.country.value,
                          "default");
                      // _categoryController
                      //     .getSubCategories(widget.categoryId.toString());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(2.0),
                        // border: Border.all(
                        //   color: Colors.grey,
                        //   width: 1.0,
                        // ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ExtendedImage.network(
                        "${storeController.storeList[index].image}",
                        // cacheWidth: 200,
                        // width: 200,
                        // enableMemoryCache: true,
                        fit: BoxFit.cover,
                        clearMemoryCacheWhenDispose: true,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        })),
        SliverFillRemaining(
          child: Obx(() {
            if (productController!.isDataProcessing.value == true &&
                productController!.productList.isEmpty) {
              return Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                child: GridView.builder(
                  physics: BouncingScrollPhysics(), // Enables scrolling
                  shrinkWrap: false, // Allows it to expand based on content
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
            if (productController!.productList.isNotEmpty &&
                productController!.isDataProcessing.value == false) {
              return Container(
                // color: Colors.red,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(), // Enables scrolling
                    shrinkWrap: false, // Allows it to expand based on content
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4 / 5.5,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: productController!.productList.length,
                    controller: productController!
                        .scrollController, // Pagination controller
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          if (BlocProvider.of<AuthenticationBloc>(context).state
                              is Authenticated) {
                            storeController.isRefresh.value = false;
                            await Get.to(() => ProductDetailPageWrapper(
                                  id: productController!.productList[index].id!,
                                  storeId:
                                      storeController.storeId.value.toString(),
                                  countryCode:
                                      storeController.country.value.toString(),
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
                                            topRight: Radius.circular(8.0),
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
                                                      .productList[index].image
                                                      .startsWith("https:")
                                                  ? productController!
                                                      .productList[index].image
                                                  : "https:${productController!.productList[index].image}",
                                              fit: BoxFit
                                                  .cover, // Use BoxFit.cover to maintain aspect ratio while covering the container
                                              cacheWidth:
                                                  600, // Adjust cache size based on how sharp you want it
                                              cacheHeight: 400,
                                              clearMemoryCacheWhenDispose: true,
                                              clearMemoryCacheIfFailed: false,
                                              loadStateChanged:
                                                  (ExtendedImageState state) {
                                                switch (state
                                                    .extendedImageLoadState) {
                                                  case LoadState.loading:
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  case LoadState.failed:
                                                    return Center(
                                                        child: Icon(
                                                            Icons.error_outline,
                                                            color: Colors.red));
                                                  case LoadState.completed:
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
                                              .productList[index].name!,
                                          textScaleFactor: 1.2,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(),
                                      Text(
                                        "${productController!.productList[index].price!} \$",
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
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // storeController.storeId.value = "taobao";
    // storeController.country.value = "china";
    // storeController.selectedStore.value = 0;
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
