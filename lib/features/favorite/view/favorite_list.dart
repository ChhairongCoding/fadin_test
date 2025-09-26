import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({Key? key}) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  final ProductController _controller = Get.find<ProductController>();
  @override
  void initState() {
    // _controller.initProductTest("1", "taobao", "china");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Container(
            padding: EdgeInsets.all(10.0),
            child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 4 / 5.5,
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8),
                itemCount: _controller.productList.length,
                // controller: _productController!.scrollController,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    // onTap: () => Get.to(() => ProductDetailPageWrapper(
                    //       name: _productController!.productList[index].name!,
                    //       price: _productController!.productList[index].price!,
                    //       image: _productController!.productList[index].image,
                    //       description: _productController!
                    //           .productList[index].description!,
                    //       promotionPrice:
                    //           _productController!.productList[index].price!,
                    //       id: _productController!.productList[index].id!,
                    //       storeId:
                    //           _productController!.productList[index].storeId!,
                    //     )),
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
                                      "https:" +
                                          _controller.productList[index].image,
                                      // errorWidget: Container(
                                      //   child: Image.asset(
                                      //       "assets/img/product-hint.jpg"),
                                      // ),
                                      cacheWidth: 400,
                                      // cacheHeight: 400,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      // color: Colors.red,
                                      child: Text(
                                        _controller.productList[index].name!,
                                        textScaleFactor: 1.2,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(),
                                    Text(
                                      "${_controller.productList[index].price.toString()} \$",
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
                }));
      }
    });
  }
}
