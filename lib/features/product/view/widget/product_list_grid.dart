import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/auth/login/view/auth_page.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/product/view/widget/product_by_category%20_shimmer.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail.dart';
import 'package:fardinexpress/features/shop/model/shop_model.dart';
import 'package:fardinexpress/utils/component/page_not_found.dart';
import 'package:fardinexpress/utils/component/widget/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProductListGrid extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String storeId;
  final String country;
  const ProductListGrid(
      {Key? key,
      required this.categoryId,
      required this.categoryName,
      required this.storeId,
      required this.country})
      : super(key: key);

  @override
  State<ProductListGrid> createState() => ProductListGridState();
}

class ProductListGridState extends State<ProductListGrid> {
  static ProductController? productController;
  // Get.find<ProductController>(tag: 'product_category');
  // Get.find<AccountController>()
  TextEditingController queryCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    productController =
        Get.put(ProductController(), tag: widget.categoryName.toString());
    productController!.initProductByStoreId(
        widget.categoryName,
        widget.categoryId,
        widget.storeId.toString(),
        "render",
        "",
        widget.country,
        "default");
    productController!.paginateProductListByStoreId(
        widget.categoryName,
        widget.categoryId,
        widget.storeId.toString(),
        "render",
        "",
        widget.country,
        "default");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (productController!.isDataProcessing.value == true &&
          productController!.productList.isEmpty) {
        return Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 4 / 5.5,
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8),
            itemCount: 8,
            itemBuilder: (context, index) {
              return ProductByCategoryShimmer();
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
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4 / 5.5,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  itemCount: productController!.productList.length,
                  controller: productController!.scrollController,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (BlocProvider.of<AuthenticationBloc>(context).state
                            is Authenticated) {
                          Get.to(() => ProductDetailPageWrapper(
                                // name: productController!.productList[index].name!,
                                // price: productController!.productList[index].price!,
                                // image: productController!.productList[index].image,
                                // description:
                                //     productController!.productList[index].name!,
                                // promotionPrice:
                                //     productController!.productList[index].price!,
                                id: productController!.productList[index].id!,
                                storeId: widget.storeId.toString(),
                                // descriptionDetail: productController!
                                //     .productList[index].description,
                                countryCode: widget.country,
                                // productController!.productList[index].storeId!,
                              ));
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
                                color: Colors.white),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0)),
                                        color: Colors.grey[350],
                                      ),
                                      margin: EdgeInsets.all(6.0),
                                      child: ExtendedImage.network(
                                        productController!
                                                .productList[index].image
                                                .contains("https:")
                                            ? productController!
                                                .productList[index].image
                                            : "https:" +
                                                productController!
                                                    .productList[index].image,
                                        // errorWidget: Container(
                                        //   child: Image.asset(
                                        //       "assets/img/image-gallery.png"),
                                        // ),
                                        cacheWidth: 400,
                                        cacheHeight: 400,
                                        // enableMemoryCache: true,
                                        clearMemoryCacheWhenDispose: true,
                                        clearMemoryCacheIfFailed: false,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
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
                                        // color: Colors.red,
                                        child: Text(
                                          productController!
                                              .productList[index].name!
                                              .toString(),
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
                            )),
                      ),
                    );
                  })),
        );
      }
      // if (productController!.productList == [] &&
      //     productController!.isDataProcessing.value == false &&
      //     productController!.isMoreDataAvailable.value == false) {
      //   return Center(
      //     child: Text("No products found!"),
      //   );
      //   // color: Colors.red,
      // }
      else {
        return EmptyDataWidget();
      }
    });
  }
}
