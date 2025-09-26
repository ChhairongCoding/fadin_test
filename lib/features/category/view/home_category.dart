import 'package:fardinexpress/features/category/controller/category_controller.dart';
import 'package:fardinexpress/features/category/view/widget/home_menu_item.dart';
import 'package:fardinexpress/features/product/view/product_by_category.dart';
import 'package:fardinexpress/features/shop/controller/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

enum PFromC { homeCategory, appDrawerCategory }

class HomeCategory extends StatefulWidget {
  final String catId;
  final PFromC pFromc;
  HomeCategory({Key? key, required this.pFromc, required this.catId})
      : super(key: key);

  @override
  State<HomeCategory> createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  final CategoryController categoryController =
      Get.put(CategoryController(), tag: "homeCategoryCtr");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryController.getCategories();
  }

  // final ProductController c = Get.find(tag: "productByStoreIdController");
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (categoryController.isLoading.value) {
        return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // childAspectRatio: 4 / 5,
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 4),
            itemCount: 12,
            itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Center(),
                              ),
                              Expanded(
                                flex: 8,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                        // shape: BoxShape.circle,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[300]!,
                                              offset: Offset(0.0, 0.5), //(x,y)
                                              blurRadius: 3.0,
                                              spreadRadius: 0.0),
                                        ],
                                        color: Colors.white),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "",
                          style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 0.8,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )));
      } else {
        return Container(
          // color: Colors.amber,
          child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // childAspectRatio: 4 / 5,
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 4),
              itemCount: categoryController.categories.length,
              itemBuilder: (context, index) => Obx(() => GestureDetector(
                  onTap: () async {
                    if (widget.pFromc == PFromC.homeCategory) {
                      // categoryController.selectedCategory.value = index;
                      Get.to(() => ProductByCategory(
                            categoryId: categoryController.categories[index].id!
                                .toString(),
                            catName: categoryController.categories[index].name!,
                            title: categoryController.categories[index].name!,
                            catIndex: index,
                          ));
                    } else {
                      ProductByCategoryState.tempCatId =
                          categoryController.categories[index].id.toString();
                      Get.back();
                      await Get.find<StoreController>(tag: "storeByCategoryCtr")
                          .getStoreList(getStoreType: 'store_list');
                      // await c.getProductByStoreId(
                      //     categoryController.categories[index].id.toString(),
                      //     storeId);
                    }
                  },
                  child: HomeCategoryItem(
                    categoryModel: categoryController.categories[index],
                    colorFont: 'black',
                  )))),
        );
      }
    });
  }
}
