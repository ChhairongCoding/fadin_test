import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/category/controller/category_controller.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/product/view/search_product_by_all_category.dart';
import 'package:fardinexpress/features/product/view/widget/product_list_grid.dart';
import 'package:fardinexpress/features/product/view/widget/product_list_grid_all.dart';
import 'package:fardinexpress/features/shop/controller/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductByCategory extends StatefulWidget {
  final String categoryId;
  final String catName;
  final String title;
  final int catIndex;
  ProductByCategory(
      {Key? key,
      required this.categoryId,
      required this.catName,
      required this.title,
      required this.catIndex})
      : super(key: key);

  @override
  State<ProductByCategory> createState() => ProductByCategoryState();
}

class ProductByCategoryState extends State<ProductByCategory>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  static String? tempCatId;
  static String? tempCatName;
  final productController =
      Get.put(ProductController(), tag: 'filter_product_category');
  late TabController _tabController;
  final StoreController _storeController =
      Get.put(StoreController(), tag: "storeByCategoryCtr");
  String _storeId = "0";
  final _categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    tempCatId = widget.categoryId.toString();
    _categoryController.selectedCategory.value = widget.catIndex;
    _storeController.initStoreList();
    _categoryController.initCategory();
    _categoryController.initSubCategory();
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
                  return Center(child: CircularProgressIndicator());
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
                          // _categoryController
                          //     .getSubCategories(widget.categoryId);
                          _storeController.country.value =
                              await _storeController.storeList[index].country
                                  .toString();
                          _storeController.selectedStore.value = index;
                          _storeController.getStoreList(
                              getStoreType: 'store_list');
                          _categoryController.initCategory();
                          _categoryController.initSubCategory();
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
                    initialIndex: 0);
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
                        indicatorColor: Colors.blue,
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
                            return ProductListGrid(
                              categoryName: e.name.toString(),
                              categoryId: widget.categoryId,
                              storeId: _storeController.storeId.value,
                              country: _storeController.country.value,
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
        icon: Icon(
            Icons.arrow_back_ios_new_outlined), // Replace with your custom icon
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
                  widget.categoryId,
                  _storeController.storeId.value,
                  _storeController.country.value));
        },
        child: Container(
            padding: EdgeInsets.all(10.0),
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
      // Text(
      //   widget.title,
      //   style: TextStyle(color: Colors.white),
      // ),
      centerTitle: false,
      // Container(
      //   width: double.infinity,
      //   child: Row(
      //     children: [
      //       Expanded(
      //         flex: 2,
      //         child: IconButton(
      //             onPressed: () {
      //               Get.find<ProductController>()
      //                   .initProductByStoreId(widget.categoryId, _storeId,
      //                       "search", queryCtr.text);
      //               Get.find<ProductController>()
      //                   .paginateProductListByStoreId(widget.categoryId,
      //                       _storeId, "search", queryCtr.text);
      //             },
      //             icon: Icon(
      //               Icons.search_outlined,
      //               color: Colors.black,
      //             )),
      //       ),
      //       SizedBox(width: 10),
      //       Expanded(
      //         flex: 8,
      //         child: TextFormField(
      //           controller: queryCtr,
      //           keyboardType: TextInputType.text,
      //           decoration: InputDecoration(hintText: "search".tr),
      //           // validator: (value) {
      //           //   if (value!.isEmpty) {
      //           //     return "required";
      //           //   }
      //           //   return null;
      //           // },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // leading: IconButton(
      //     onPressed: () => Navigator.pop(_),
      //     icon: Icon(Icons.arrow_back_ios_new_rounded)),
      // actions: [
      //   Builder(builder: (c) {
      //     return IconButton(
      //         onPressed: () {
      //           Scaffold.of(c).openEndDrawer();
      //         },
      //         icon: Icon(
      //           Icons.manage_search_rounded,
      //           size: 30,
      //         ));
      //   }),
      // ],
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
                                ProductListGridState.productController!
                                    .initProductByStoreId(
                                        tempCatName!,
                                        tempCatId!,
                                        _storeController.storeId.value,
                                        "render",
                                        "",
                                        _storeController.country.value,
                                        "price_asc");

                                ProductListGridState.productController!
                                    .paginateProductListByStoreId(
                                        tempCatName!,
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
                        //         backgroundColor: Colors.green.shade300,
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(8)),
                        //       ),
                        //       onPressed: () {
                        //         ProductListGridState.productController!
                        //             .initProductByStoreId(
                        //                 tempCatId!,
                        //                 _storeController.storeId.value,
                        //                 "render",
                        //                 "",
                        //                 _storeController.country.value,
                        //                 "price_des");

                        //         ProductListGridState.productController!
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
                      child: Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              // elevation: 0,
                              backgroundColor: Colors.green.shade400,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                            ),
                            onPressed: () {
                              ProductListGridState.productController!
                                  .initProductByStoreId(
                                      tempCatName!,
                                      tempCatId!,
                                      _storeController.storeId.value,
                                      "render",
                                      "",
                                      _storeController.country.value,
                                      "price_des");

                              ProductListGridState.productController!
                                  .paginateProductListByStoreId(
                                      tempCatName!,
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
                                Icon(Icons.arrow_downward_outlined,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "Descending",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            )),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          // elevation: 0,
                          backgroundColor: Colors.green.shade400,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                        onPressed: () {
                          ProductListGridState.productController!
                              .initProductByStoreId(
                                  tempCatName!,
                                  tempCatId!,
                                  _storeController.storeId.value,
                                  "render",
                                  "",
                                  _storeController.country.value,
                                  "default");

                          ProductListGridState.productController!
                              .paginateProductListByStoreId(
                                  tempCatName!,
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
    // int initPosition = 0;
    return Container(
      // margin: EdgeInsets.only(top: 10.0),
      child: ProductListGrid(
        categoryId: "0",
        storeId: _storeController.storeId.value,
        country: _storeController.country.value,
        categoryName: '',
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }
}
