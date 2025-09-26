import 'dart:developer';
import 'dart:io';

import 'package:fardinexpress/features/product/controller/product_repository.dart';
import 'package:fardinexpress/features/product/model/product_model.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  bool isFetching = false;
  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;
  RxString initCategoryId = "".obs;
  List<ProductModel> productList = <ProductModel>[].obs;
  List<ProductModel> productListSearch = <ProductModel>[].obs;
  ProductModelRes? productDetail;
  // var productList = List<ProductModel>.empty(growable: true).obs;
  // <ProductModel>[].obs;
  List<String> images = [];
  ApiProvider apiProvider = ApiProvider();
  ProductRepository productRepository = ProductRepository();
  ScrollController scrollController = ScrollController();
  // final String? categoryId;
  int page = 1;
  int rowPerPage = 12;
  TextEditingController startPriceController = TextEditingController();
  TextEditingController endPriceController = TextEditingController();
  RxString reqProductDetailUrl = "".obs;

  RxString imageUrl = "".obs;

  // common snack bar
  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor,
        colorText: Colors.white);
  }

  // ProductController() {
  //   initProductTest("1");
  // }

  // initProductTest(String categoriesId, String store, String country) async {
  //   try {
  //     isLoading(true);
  //     await productRepository
  //         .fetchProductLists(
  //             page: page,
  //             rowPerPage: rowPerPage,
  //             categoryId: categoriesId,
  //             store: store,
  //             country: country)
  //         .then((resp) {
  //       isLoading(false);
  //       productList.addAll(resp);
  //     }, onError: (err) {
  //       isLoading(false);
  //       // showSnackBar("Error", err.toString(), Colors.red);
  //       log(err.toString());
  //     });
  //   } catch (e) {
  //     isDataProcessing(false);
  //     // showSnackBar("Exception", e.toString(), Colors.red);
  //     log(e.toString());
  //   }
  // }

  initProduct(String categoriesId, String categoriesName, String store,
      String country) async {
    try {
      isMoreDataAvailable(false);
      isDataProcessing(true);
      await productRepository
          .fetchProductLists(
              page: page,
              rowPerPage: rowPerPage,
              categoryId: categoriesId,
              categoryName: categoriesName,
              store: store,
              country: country)
          .then((resp) async {
        // for (var product in resp) {
        //   final tProductName = product.name!;
        //   final translatedName =
        //       await apiProvider.gTranslate(keyword: tProductName);
        //   product.name = translatedName;
        // }
        productList.addAll(resp);
        isDataProcessing(false);
      }, onError: (err) {
        isDataProcessing(false);
        // showSnackBar("Error", err.toString(), Colors.red);
        log(err.toString());
      });
    } catch (e) {
      isDataProcessing(false);
      // showSnackBar("Exception", e.toString(), Colors.red);
      log(e.toString());
    }
  }

  paginateProductList(
      String categoryId, String categoryName, String store, String country) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreProductList(page, categoryId, categoryName, store, country);
      }
    });
  }

  getMoreProductList(var page, var categoryId, var categoryName, String store,
      String country) async {
    try {
      await productRepository
          .fetchProductLists(
              page: page,
              rowPerPage: rowPerPage,
              categoryId: categoryId,
              categoryName: categoryName,
              store: store,
              country: country)
          .then((resp) async {
        if (resp.length > rowPerPage) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
          // for (var product in resp) {
          //   final tProductName = product.name!;
          //   final translatedName =
          //       await apiProvider.gTranslate(keyword: tProductName);
          //   product.name = translatedName;
          // }
          // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
        }
        productList.addAll(resp);
      }, onError: (err) {
        isMoreDataAvailable(false);
        // showSnackBar("Error", err.toString(), Colors.red);
        log(err.toString());
      });
    } catch (e) {
      isMoreDataAvailable(false);
      // showSnackBar("Exception", e.toString(), Colors.red);
      log(e.toString());
    }
  }

  initProductByStoreId(String categoriesName, String categoriesId,
      String storeId, String type, String query, country, String sort) async {
    try {
      if (isMoreDataAvailable(true) && productList.isNotEmpty) {
        productList.clear();
      }
      page = 1;
      isDataProcessing(true);
      await productRepository
          .fetchProductListsByStore(
              page: page,
              rowPerPage: rowPerPage,
              categoryName: categoriesName,
              categoryId: categoriesId,
              storeId: storeId,
              type: type,
              query: query,
              country: country,
              sort: sort)
          .then((resp) async {
        // for (var product in resp) {
        //   final tProductName = product.name!;
        //   final translatedName =
        //       await apiProvider.gTranslate(keyword: tProductName);
        //   product.name = translatedName;
        // }
        productList.addAll(resp);
        isDataProcessing(false);
      }, onError: (err) {
        isDataProcessing(false);
        // showSnackBar("Error", err.toString(), Colors.red);
        log(err.toString());
      });
    } catch (e) {
      isDataProcessing(false);
      // showSnackBar("Exception", e.toString(), Colors.red);
      log(e.toString());
    }
  }

  paginateProductListByStoreId(String categoryName, String categoryId,
      String storeId, String type, String query, String country, String sort) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreProductListByStoreId(page, categoryName, categoryId, storeId,
            type, query, country, sort);
      }
      print("return empty list");
    });
  }

  getMoreProductListByStoreId(
      var page,
      var categoryName,
      var categoryId,
      var storeId,
      String type,
      String query,
      String country,
      String sort) async {
    try {
      await productRepository
          .fetchProductListsByStore(
              page: page,
              rowPerPage: rowPerPage,
              categoryName: categoryName,
              categoryId: categoryId,
              storeId: storeId,
              query: query,
              type: type,
              country: country,
              sort: sort)
          .then((resp) async {
        if (resp.length > rowPerPage) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
          // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
          // for (var product in resp) {
          //   final tProductName = product.name!;
          //   final translatedName =
          //       await apiProvider.gTranslate(keyword: tProductName);
          //   product.name = translatedName;
          // }
        }
        productList.addAll(resp);
      }, onError: (err) {
        isMoreDataAvailable(false);
        // showSnackBar("Error", err.toString(), Colors.red);
        log(err.toString());
      });
    } catch (e) {
      isMoreDataAvailable(false);
      // showSnackBar("Exception", e.toString(), Colors.red);
      log(e.toString());
    }
  }

  initSearchProduct(String query) async {
    try {
      isMoreDataAvailable(false);
      isDataProcessing(true);
      await productRepository
          .searchProductLists(page: page, rowPerPage: rowPerPage, query: query)
          .then((resp) {
        isDataProcessing(false);
        productList.addAll(resp);
      }, onError: (err) {
        isDataProcessing(false);
        // showSnackBar("Error", err.toString(), Colors.red);
        log(err.toString());
      });
    } catch (e) {
      isDataProcessing(false);
      // showSnackBar("Exception", e.toString(), Colors.red);
      log(e.toString());
    }
  }

  paginateSearchProduct(String query) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreProductListSearch(page, query);
      }
    });
  }

  getMoreProductListSearch(
    var page,
    var query,
  ) async {
    try {
      await productRepository
          .searchProductLists(page: page, rowPerPage: rowPerPage, query: query)
          .then((resp) {
        if (resp.length > rowPerPage) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
          // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
        }
        productList.addAll(resp);
      }, onError: (err) {
        isMoreDataAvailable(false);
        // showSnackBar("Error", err.toString(), Colors.red);
        log(err.toString());
      });
    } catch (e) {
      isMoreDataAvailable(false);
      // showSnackBar("Exception", e.toString(), Colors.red);
      log(e.toString());
    }
  }

  Future<void> getProductDetail({
    required String productId,
    required String storeId,
    required String country,
  }) async {
    productDetail = null;
    try {
      isFetching = true;
      update(); // Immediately notify UI that fetching has started

      final value = await productRepository.fetchProductDetails(
        productId: productId,
        storeId: storeId,
        country: country,
      );

      if (value.id != null) {
        productDetail = value;
        reqProductDetailUrl.value = productDetail!.webUrl!;
        // Optionally process images:
        // images = productDetail.image?.map((e) => "https:$e").toList() ?? [];
      } else {
        // assign productDetail to null if id is null
        productDetail = null;
      }
    } catch (e) {
      log("Error in getProductDetail: ${e.toString()}");
      // showSnackBar("Exception", e.toString(), Colors.red);
    } finally {
      isFetching = false;
      update(); // Always update UI regardless of success/failure
    }
  }

  // getProductDetail(
  //     {required String productId,
  //     required String storeId,
  //     required String country}) async {
  //   try {
  //     isFetching = true;
  //     await productRepository
  //         .fetchProductDetails(
  //             productId: productId, storeId: storeId, country: country)
  //         .then((value) {
  //           productDetail = value;
  //           if(productDetail.id != null){
  //              productDetail = value;
  //       reqProductDetailUrl.value = productDetail.webUrl!;
  //       // "https://fardinexpress.asia/api/$storeId?api=item_detail_simple&num_iid=$productId&country=$country";
  //       // productDetail.image!.forEach((element) {
  //       //   images.add("https:" + element);
  //       // });
  //       isFetching = false;
  //       update();
  //           }else{
  //             isFetching = false;
  //             update();
  //           }
  //     });
  //   } catch (e) {
  //     isFetching = false;
  //     // showSnackBar("Exception", e.toString(), Colors.red);
  //     log(e.toString());
  //   }
  // }

  getProductFromURL({required String webUrl}) async {
    try {
      isFetching = true;
      await productRepository.fetchProductByUrl(webUrl: webUrl).then((value) {
        productDetail = value;
        reqProductDetailUrl.value = productDetail!.webUrl!;
        isFetching = false;
        // update();
        Get.off(() => ProductDetailPageWrapper(
            storeId: productDetail!.storeCode!,
            id: productDetail!.id.toString(),
            countryCode: productDetail!.countryCode!.toString()));
      });
    } catch (e) {
      isFetching = false;
      log(e.toString());
    }
  }

  searchProductByImage({required File? image, required String storeId}) async {
    try {
      productListSearch.clear();
      isFetching = true;
      EasyLoading.show(
        status: 'Searching...',
      );
      // String imageUrl = '';
      if (image != null) {
        imageUrl.value = await apiProvider.uploadImage(image: image);
        isFetching = false;
        EasyLoading.dismiss();
        initProductByImageSearch(imageUrl.value, storeId);
        paginateProFromSearchImg(imageUrl.value, storeId);
      } else {
        isFetching = false;
        EasyLoading.dismiss();
        Alert(
          onWillPopActive: true,
          type: AlertType.error,
          context: Get.context!,
          closeIcon: Container(),
          style: AlertStyle(
            titlePadding: EdgeInsets.all(0),
            descTextAlign: TextAlign.center,
            descStyle: TextStyle(
              fontSize: 18,
            ),
          ),
          title: "no_data".tr,
          desc: "alert".tr,
          buttons: [
            DialogButton(
              child: Text(
                "done".tr,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(Get.context!);
              },
              color: Colors.blue,
              radius: BorderRadius.circular(8.0),
            ),
          ],
        ).show();
      }
    } catch (e) {
      isFetching = false;
      EasyLoading.dismiss();
      // showSnackBar("Exception", e.toString(), Colors.red);
      log(e.toString());
    }
  }

  initProductByImageSearch(String imageUrl, String store) async {
    try {
      isMoreDataAvailable(false);
      isDataProcessing(true);

      final resp = await productRepository.fetchProductByImage(
        imageUrl: imageUrl,
        store: store,
        page: page,
        rowPerPage: rowPerPage,
      );

      // Optionally translate product names
      // for (var product in resp) {
      //   final tProductName = product.name!;
      //   final translatedName = await apiProvider.gTranslate(keyword: tProductName);
      //   product.name = translatedName;
      // }

      productListSearch.addAll(resp);

      // Decide whether there's more data for pagination
      isMoreDataAvailable(resp.length >= rowPerPage);
    } catch (e) {
      log('Error in initProductByImageSearch: $e');
    } finally {
      isDataProcessing(false);
    }
  }

  paginateProFromSearchImg(String imageUrl, String store) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreProFromSearchImg(page, store, imageUrl);
      }
    });
  }

  Future<void> getMoreProFromSearchImg(
      var page, String store, String imageUrl) async {
    try {
      final resp = await productRepository.fetchProductByImage(
        imageUrl: imageUrl,
        store: store,
        page: page,
        rowPerPage: rowPerPage,
      );

      // Check if there's potentially more data to load
      isMoreDataAvailable(resp.length > rowPerPage);

      // Optionally translate product names here
      // for (var product in resp) {
      //   final translatedName = await apiProvider.gTranslate(keyword: product.name!);
      //   product.name = translatedName;
      // }

      productListSearch.addAll(resp);

      if (resp.isEmpty) {
        // Optionally show a snack bar when no data is returned
        // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
      }
    } catch (err) {
      isMoreDataAvailable(false);
      log("Error fetching products by image: $err");
      // showSnackBar("Error", err.toString(), Colors.red);
    }
  }

  initSortProductByPrice(String categoriesId, String storeId, String startPrice,
      String endPrice, country) async {
    try {
      if (isMoreDataAvailable(true) && productList.isNotEmpty) {
        productList.clear();
      }
      page = 1;
      isDataProcessing(true);
      await productRepository
          .fetchSortProductsByPrice(
              page: page,
              rowPerPage: rowPerPage,
              categoryId: categoriesId,
              storeId: storeId,
              startPrice: startPrice,
              endPrice: endPrice,
              country: country)
          .then((resp) async {
        // for (var product in resp) {
        //   final tProductName = product.name!;
        //   final translatedName =
        //       await apiProvider.gTranslate(keyword: tProductName);
        //   product.name = translatedName;
        // }
        productList.addAll(resp);
        isDataProcessing(false);
      }, onError: (err) {
        isDataProcessing(false);
        // showSnackBar("Error", err.toString(), Colors.red);
        log(err.toString());
      });
    } catch (e) {
      isDataProcessing(false);
      // showSnackBar("Exception", e.toString(), Colors.red);
      log(e.toString());
    }
  }

  paginateSortProductsByPrice(String categoryId, String storeId,
      String startPrice, String endPrice, String country) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreSortProductsByPrice(
            page, categoryId, storeId, startPrice, endPrice, country);
      }
      print("return empty list");
    });
  }

  getMoreSortProductsByPrice(var page, var categoryId, var storeId,
      String startPrice, String endPrice, String country) async {
    try {
      await productRepository
          .fetchSortProductsByPrice(
              page: page,
              rowPerPage: rowPerPage,
              categoryId: categoryId,
              storeId: storeId,
              startPrice: startPrice,
              endPrice: endPrice,
              country: country)
          .then((resp) async {
        if (resp.length > rowPerPage) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
          // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
          // for (var product in resp) {
          //   final tProductName = product.name!;
          //   final translatedName =
          //       await apiProvider.gTranslate(keyword: tProductName);
          //   product.name = translatedName;
          // }
        }
        productList.addAll(resp);
      }, onError: (err) {
        isMoreDataAvailable(false);
        // showSnackBar("Error", err.toString(), Colors.red);
        log(err.toString());
      });
    } catch (e) {
      isMoreDataAvailable(false);
      // showSnackBar("Exception", e.toString(), Colors.red);
      log(e.toString());
    }
  }
}
