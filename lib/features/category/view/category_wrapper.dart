import 'package:fardinexpress/features/category/controller/category_controller.dart';
import 'package:fardinexpress/features/product/view/product_by_all_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';

class CategoryWrapper extends StatefulWidget {
  const CategoryWrapper({Key? key}) : super(key: key);

  @override
  State<CategoryWrapper> createState() => _CategoryWrapperState();
}

class _CategoryWrapperState extends State<CategoryWrapper> {
  final CategoryController _categoryController =
      Get.put(CategoryController(), tag: "categoryWrapper");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryController.initCategory();
    _categoryController.initSubCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
        centerTitle: true,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Obx(() {
                if (_categoryController.isLoading.value) {
                  if (_categoryController.backupCategories.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container(
                        child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _categoryController.backupCategories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // border: isSelected
                              //     ? Border.all(color: Colors.green, width: 2)
                              //     : null,
                            ),
                            height: 70.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  "${_categoryController.backupCategories[index].image}",
                                  width: 30.0,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image_not_supported,
                                        size: 30.0);
                                  },
                                ),
                                Text(
                                  '${_categoryController.backupCategories[index].name!.split(RegExp(r'[,\s]+'))[0]}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ));
                  }
                } else {
                  return Container(
                    child: Obx(() => ListView.builder(
                          shrinkWrap: true,
                          itemCount: _categoryController.categories.length,
                          itemBuilder: (context, index) {
                            bool isSelected = index ==
                                _categoryController.selectedCategory.value;
                            return GestureDetector(
                              onTap: () {
                                _categoryController.selectedCategory.value =
                                    index; // Update selected index
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      isSelected ? Colors.green : Colors.white,
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.green, width: 2)
                                      : null,
                                ),
                                height: 70.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      "${_categoryController.categories[index].image}",
                                      width: 30.0,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.image_not_supported,
                                            size: 30.0);
                                      },
                                    ),
                                    Text(
                                      '${_categoryController.categories[index].name!.split(RegExp(r'[,\s]+'))[0]}',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                  );
                }
              })),
          Expanded(
            flex: 8,
            child: Container(
              // margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0),
              // color: Colors.red,
              child: Column(
                // physics: NeverScrollableScrollPhysics(),
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 1,
                    child: Image.network(
                      "http://delivery.anakutapp.com/assets/uploads/76679f576dff6dea0bda2c720b502fd5.jpg",
                      fit: BoxFit.cover,
                      // height: 200,
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    if (_categoryController.isLoading.value) {
                      return Container();
                      // GridView.builder(
                      //     shrinkWrap: true,
                      //     gridDelegate:
                      //         SliverGridDelegateWithFixedCrossAxisCount(
                      //             childAspectRatio: 1,
                      //             crossAxisCount: 3,
                      //             crossAxisSpacing: 5,
                      //             mainAxisSpacing: 5),
                      //     itemCount: 1,
                      //     itemBuilder: (context, index) {
                      //       return Shimmer.fromColors(
                      //         baseColor: Colors.grey[300]!,
                      //         highlightColor: Colors.grey[100]!,
                      //         child: GestureDetector(
                      //           onTap: () {},
                      //           child: Container(
                      //             child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 Container(
                      //                   padding: EdgeInsets.all(15.0),
                      //                   decoration: BoxDecoration(
                      //                       border: Border.all(
                      //                         color: Colors.green[100]!,
                      //                         width: 2.0,
                      //                       ),
                      //                       color: Colors.white,
                      //                       shape: BoxShape.circle),
                      //                   child: Container(
                      //                     child: Text(""),
                      //                     width: 80.0,
                      //                   ),
                      //                 ),
                      //                 Text(
                      //                   "",
                      //                   maxLines: 1,
                      //                   overflow: TextOverflow.visible,
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     });
                    } else {
                      return Expanded(
                        child: GridView.builder(
                            // shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2.2 / 3,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemCount: _categoryController.subCategories.length,
                            itemBuilder: (context, index) {
                              var subCategory =
                                  _categoryController.subCategories[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => ProductByAllCategory(
                                        categoryId: _categoryController
                                            .categories[_categoryController
                                                .selectedCategory.value]
                                            .id
                                            .toString(),
                                        title: 'Category',
                                        categoryIndex: index,
                                        subCategoryId:
                                            subCategory.name.toString(),
                                      ));
                                },
                                child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.green[100]!,
                                                width: 2.0,
                                              ),
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: Image.network(
                                            subCategory.image.toString(),
                                            width: 40.0,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          (loadingProgress
                                                                  .expectedTotalBytes ??
                                                              1)
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/img/image-gallery.png',
                                                width: 40.0,
                                              ); // Fallback image
                                            },
                                          )

                                          // Image.network(
                                          //   subCategory.image.toString(),
                                          //   width: 40.0,
                                          // ),
                                          ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        subCategory.name.toString(),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
