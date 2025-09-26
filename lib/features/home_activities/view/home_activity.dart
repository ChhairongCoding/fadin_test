import 'package:fardinexpress/features/category/controller/category_controller.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/product/view/product_by_category.dart';
import 'package:fardinexpress/features/product/view/widget/product_scroll_horizontal.dart';
import 'package:fardinexpress/features/shop/controller/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeActivity extends StatefulWidget {
  HomeActivity({Key? key}) : super(key: key);

  @override
  State<HomeActivity> createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  final _categoryController =
      Get.find<CategoryController>(tag: "homeActivityCtr");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryController.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_categoryController.isLoading.value) {
        return Container();
      }
      if (_categoryController.categories.isEmpty) {
        return Center(child: Text("No categories found"));
      } else {
        return ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categoryController.categories.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              ProductController productController =
                  Get.put(ProductController(), tag: index.toString());
              productController.productList.clear();
              productController.initProduct(
                  _categoryController.categories[index].id.toString(),
                  _categoryController.categories[index].name.toString(),
                  "${Get.find<StoreController>(tag: "initHomeStoreCtr").storeId.value}",
                  "${Get.find<StoreController>(tag: "initHomeStoreCtr").country.value}");
              productController.paginateProductList(
                  _categoryController.categories[index].id.toString(),
                  _categoryController.categories[index].name.toString(),
                  "${Get.find<StoreController>(tag: "initHomeStoreCtr").storeId.value}",
                  "${Get.find<StoreController>(tag: "initHomeStoreCtr").country.value}");
              if (index == productController.productList.length - 1 &&
                  productController.isMoreDataAvailable.value == true) {
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                margin: EdgeInsets.only(bottom: 15.0),
                decoration: BoxDecoration(
                    color: Colors.green[800],
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _categoryController.categories[index].name!,
                            textScaleFactor: 1.1,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () => Get.to(() => ProductByCategory(
                                    categoryId: _categoryController
                                        .categories[index].name
                                        .toString(),
                                    title: _categoryController
                                        .categories[index].name!,
                                    catIndex: index,
                                    catName: _categoryController
                                        .categories[index].name!,
                                  )),
                              child: Text("viewAll".tr,
                                  textScaleFactor: 1.1,
                                  style: TextStyle(color: Colors.white)))
                        ],
                      ),
                    ),
                    // ProductScrollHorizontal(
                    //     categoryId: _categoryController.categories[index].id
                    //         .toString()),
                    Obx(() {
                      if (productController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (productController.productList.isEmpty) {
                        return Container(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Center(
                                child: Text(
                              "No products found",
                              style: TextStyle(color: Colors.white),
                            )));
                      } else {
                        return AspectRatio(
                          aspectRatio: 5 / 3,
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: productController.scrollController,
                              // physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 10.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: productController.productList.length,
                              itemBuilder: (context, index) {
                                return ProductScrollHorizontal(
                                  productModel:
                                      productController.productList[index],
                                  storeId:
                                      '${Get.find<StoreController>(tag: "initHomeStoreCtr").storeId.value}',
                                  countryCode:
                                      '${Get.find<StoreController>(tag: "initHomeStoreCtr").country.value}',
                                );
                              }),
                        );
                      }
                    }),
                  ],
                ),
              );
            });
      }
    });
  }
}
