import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/category/controller/category_controller.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/product/view/search_product_by_all_category.dart';
import 'package:fardinexpress/features/product/view/widget/product_list_grid_all.dart';
import 'package:fardinexpress/features/shop/controller/store_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProductByAllCategory extends StatefulWidget {
  final String subCategoryId;
  final String categoryId;
  final String title;
  final int categoryIndex;
  ProductByAllCategory(
      {Key? key,
      required this.subCategoryId,
      required this.title,
      required this.categoryIndex,
      required this.categoryId})
      : super(key: key);

  @override
  State<ProductByAllCategory> createState() => ProductByAllCategoryState();
}

class ProductByAllCategoryState extends State<ProductByAllCategory>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  static String? tempSubCatId;
  static String? tempCatId;
  final productController =
      Get.put(ProductController(), tag: 'filter_product_all_category');
  late TabController _tabController;
  final StoreController _storeController =
      Get.put(StoreController(), tag: "storeByAllCategoryCtr");
  String _storeId = "0";
  final _categoryController =
      Get.find<CategoryController>(tag: "categoryWrapper");

  @override
  void initState() {
    super.initState();
    tempSubCatId = widget.subCategoryId.toString();
    tempCatId = widget.categoryId.toString();
    _storeController.initStoreList();
    // _categoryController.initSubCategory();
    // _categoryController.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildAppDrawer(context),
      body: CustomScrollView(
        slivers: [
          // Store List Section
          SliverToBoxAdapter(
            child: Obx(() {
              if (_storeController.isLoading.value) {
                if (_storeController.backupStoreList.isEmpty) {
                  return Container();
                } else {
                  return SizedBox(
                    height: 40, // Fixed height for the horizontal store list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _storeController.backupStoreList.length,
                      itemBuilder: (context, index) {
                        // bool isSelected =
                        //     index == _storeController.selectedStore.value;
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ExtendedImage.network(
                              "${_storeController.backupStoreList[index].image}",
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
                    itemCount: _storeController.storeList.length,
                    itemBuilder: (context, index) {
                      bool isSelected =
                          index == _storeController.selectedStore.value;
                      return GestureDetector(
                        onTap: () async {
                          _storeController.storeId.value =
                              await _storeController.storeList[index].id
                                  .toString();
                          _storeController.country.value =
                              await _storeController.storeList[index].country
                                  .toString();
                          _storeController.selectedStore.value = index;
                          _storeController.getStoreList(
                              getStoreType: 'store_list');
                          _categoryController
                              .getSubCategories(widget.categoryId.toString());
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
                            "${_storeController.storeList[index].image}",
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
            }),
          ),

          // Category List with Tabs
          SliverFillRemaining(
            child: Obx(() {
              if (_categoryController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                _tabController = TabController(
                    length: _categoryController.subCategories.length,
                    vsync: this,
                    initialIndex: widget.categoryIndex);
                return DefaultTabController(
                  length: _categoryController.subCategories.length,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        controller: _tabController,
                        // TabController(
                        //     length: _categoryController.subCategories.length,
                        //     vsync: this,
                        //     initialIndex: widget.categoryIndex),
                        isScrollable: true,
                        labelColor: Colors.black,
                        dividerColor: Colors.transparent,
                        // onTap: (int index) {
                        //   setState(() {
                        //     tempCatId = _categoryController
                        //         .subCategories[index].id
                        //         .toString();
                        //   });
                        // },
                        // padding: EdgeInsets.symmetric(horizontal: 10.0),
                        // labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.green,
                        tabs: _categoryController.subCategories
                            .map((e) => Tab(text: e.name))
                            .toList(),
                      ),
                      // Allow dynamic scrolling for each TabBarView child
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          // TabController(
                          //     length: _categoryController.subCategories.length,
                          //     vsync: this,
                          //     initialIndex: widget.categoryIndex),
                          children: _categoryController.subCategories.map((e) {
                            _storeController.subCategoryId.value =
                                e.name.toString();
                            return ProductListGridAll(
                              categoryId: tempCatId!,
                              storeId: _storeController.storeId.value,
                              country: _storeController.country.value,
                              categoryName: e.name.toString(),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  _buildAppBar(_) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      // Theme.of(context).primaryColor,
      iconTheme: IconThemeData(color: Colors.black),
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios)),
      actions: [
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.sort), // Replace with your custom icon
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ],
      title: GestureDetector(
        onTap: () {
          showSearch(
              context: context,
              delegate: SearchProductByAllCategory(
                  widget.categoryId.toString(),
                  _storeController.storeId.value,
                  _storeController.country.value));
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30.0)),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[800]),
                Text(
                  " ស្វែងរក",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800]),
                ),
              ],
            )),
      ),
      centerTitle: true,
    );
  }

  _buildAppDrawer(_) {
    return Drawer(
      child: Form(
        key: _key,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(Icons.sort, color: Colors.grey),
                        SizedBox(width: 10),
                        Text(
                          "Sort".toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // elevation: 0,
                                alignment: Alignment.centerLeft,
                                backgroundColor: Colors.green.shade400,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                              onPressed: () {
                                ProductListGridAllState.productController!
                                    .initProductByStoreId(
                                        tempSubCatId!,
                                        tempCatId!,
                                        _storeController.storeId.value,
                                        "render",
                                        "",
                                        _storeController.country.value,
                                        "price_asc");

                                ProductListGridAllState.productController!
                                    .paginateProductListByStoreId(
                                        tempSubCatId!,
                                        tempCatId!,
                                        _storeController.storeId.value,
                                        "render",
                                        "",
                                        _storeController.country.value,
                                        "price_asc");
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_upward_outlined,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Ascending",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              )),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Expanded(
                        //   child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         // elevation: 0,
                        //         backgroundColor: Colors.amber,
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(8)),
                        //       ),
                        //       onPressed: () {
                        //         ProductListGridAllState.productController!
                        //             .initProductByStoreId(
                        //                 tempCatId!,
                        //                 _storeController.storeId.value,
                        //                 "render",
                        //                 "",
                        //                 _storeController.country.value,
                        //                 "price_des");

                        //         ProductListGridAllState.productController!
                        //             .paginateProductListByStoreId(
                        //                 tempCatId!,
                        //                 _storeController.storeId.value,
                        //                 "render",
                        //                 "",
                        //                 _storeController.country.value,
                        //                 "price_des");
                        //         Navigator.pop(context);
                        //       },
                        //       child: Text(
                        //         "Descending",
                        //         style: TextStyle(
                        //             fontWeight: FontWeight.w600,
                        //             color: Colors.grey[800]),
                        //       )),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // elevation: 0,
                          alignment: Alignment.centerLeft,
                          backgroundColor: Colors.green.shade400,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                        onPressed: () {
                          ProductListGridAllState.productController!
                              .initProductByStoreId(
                                  tempSubCatId!,
                                  tempCatId!,
                                  _storeController.storeId.value,
                                  "render",
                                  "",
                                  _storeController.country.value,
                                  "price_des");

                          ProductListGridAllState.productController!
                              .paginateProductListByStoreId(
                                  tempSubCatId!,
                                  tempCatId!,
                                  _storeController.storeId.value,
                                  "render",
                                  "",
                                  _storeController.country.value,
                                  "price_des");
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_upward_outlined,
                                color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Ascending",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // elevation: 0,
                          alignment: Alignment.centerLeft,
                          // elevation: 0,
                          backgroundColor: Colors.green.shade400,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                        onPressed: () {
                          ProductListGridAllState.productController!
                              .initProductByStoreId(
                                  tempSubCatId!,
                                  tempCatId!,
                                  _storeController.storeId.value,
                                  "render",
                                  "",
                                  _storeController.country.value,
                                  "default");

                          ProductListGridAllState.productController!
                              .paginateProductListByStoreId(
                                  tempSubCatId!,
                                  tempCatId!,
                                  _storeController.storeId.value,
                                  "render",
                                  "",
                                  _storeController.country.value,
                                  "default");
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.filter_alt_off, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Comprehensive",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         elevation: 0,
            //         shape: RoundedRectangleBorder(
            //           borderRadius:
            //               BorderRadius.circular(14), // Set border radius
            //         ),
            //         backgroundColor: Theme.of(context).primaryColor,
            //       ),
            //       onPressed: () {
            //         // Handle filter action here
            //         if (_key.currentState!.validate()) {
            //           productController.productList.clear();
            //           productController.initSortProductByPrice(
            //               _storeController.subCategoryId.value,
            //               _storeController.storeId.value,
            //               productController.startPriceController.text,
            //               productController.endPriceController.text,
            //               _storeController.country.value);
            //           productController.paginateSortProductsByPrice(
            //               _storeController.subCategoryId.value,
            //               _storeController.storeId.value,
            //               productController.startPriceController.text,
            //               productController.endPriceController.text,
            //               _storeController.country.value);
            //           Get.back();
            //         }
            //       },
            //       child: Text(
            //         "Apply Filter",
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _buildBody(_) {
    int initPosition = 0;
    return Container(
        // margin: EdgeInsets.only(top: 10.0),
        child: ProductListGridAll(
      categoryId: tempCatId!,
      categoryName: tempSubCatId!,
      storeId: _storeController.storeId.value,
      country: _storeController.country.value,
    ));
    // );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }
}
