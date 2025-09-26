import 'dart:developer';

import 'package:fardinexpress/features/cart/controller/cart_store_repository.dart';
import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:fardinexpress/features/product/controller/product_repository.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartStoreController extends GetxController {
  var isLoading = false.obs;
  CartStoreModel? cartStoreList;
  ProductModelRes? productModel;
  List<ProductModelRes> productListFromTaobao = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromAmazon = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromLazada = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromFrom1688 = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromFardin = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromAmazonau = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromLazadavn = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromAmazonfr = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromAmazonin = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromAmazonit = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromAmazonde = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromAmazonae = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromAmazonjp = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromLazadath = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromLazadasg = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromLazadaid = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromLazadamy = <ProductModelRes>[].obs;
  List<ProductModelRes> productListFromLazadaph = <ProductModelRes>[].obs;

  CartStoreRepository _cartRepository = CartStoreRepository();
  ProductRepository _productRepository = ProductRepository();
  ScrollController scrollController = ScrollController();
  int page = 1;
  int rowPerPage = 30;
  var cartQty = 0.obs;

  @override
  void onInit() async {
    getCartStoreList();
    super.onInit();
  }

  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  getCartStoreList() async {
    try {
      isLoading(true);
      cartQty.value = 0;
      // Clear product lists
      productListFromTaobao.clear();
      productListFromAmazon.clear();
      productListFromLazada.clear();
      productListFromFrom1688.clear();
      productListFromFardin.clear();
      productListFromAmazonau.clear();
      productListFromLazadavn.clear();
      productListFromAmazonfr.clear();
      productListFromAmazonin.clear();
      productListFromAmazonit.clear();
      productListFromAmazonde.clear();
      productListFromAmazonae.clear();
      productListFromAmazonjp.clear();
      productListFromLazadath.clear();
      productListFromLazadasg.clear();
      productListFromLazadaid.clear();
      productListFromLazadamy.clear();
      productListFromLazadaph.clear();
      update();

      // Fetch cart store list
      cartStoreList = await _cartRepository.fetchCartStoreList();
      cartQty.value += cartStoreList?.taobao.length ?? 0;
      cartQty.value += cartStoreList?.amazon.length ?? 0;
      cartQty.value += cartStoreList?.lazada.length ?? 0;
      cartQty.value += cartStoreList?.from1688.length ?? 0;
      cartQty.value += cartStoreList?.fardin.length ?? 0;
      cartQty.value += cartStoreList?.amazonau.length ?? 0;
      cartQty.value += cartStoreList?.lazadavn.length ?? 0;
      cartQty.value += cartStoreList?.amazonfr.length ?? 0;
      cartQty.value += cartStoreList?.amazonin.length ?? 0;
      cartQty.value += cartStoreList?.amazonit.length ?? 0;
      cartQty.value += cartStoreList?.amazonde.length ?? 0;
      cartQty.value += cartStoreList?.amazonae.length ?? 0;
      cartQty.value += cartStoreList?.amazonjp.length ?? 0;
      cartQty.value += cartStoreList?.lazadath.length ?? 0;
      cartQty.value += cartStoreList?.lazadasg.length ?? 0;
      cartQty.value += cartStoreList?.lazadaid.length ?? 0;
      cartQty.value += cartStoreList?.lazadamy.length ?? 0;
      cartQty.value += cartStoreList?.lazadaph.length ?? 0;

      // Define store fetch function
      Future<void> fetchProducts(List<dynamic>? storeList, String storeId,
          String country, List<ProductModelRes> productList) async {
        if (storeList?.isNotEmpty ?? false) {
          await Future.wait(storeList!.map((element) async {
            try {
              var item = await _productRepository.fetchProductDetails(
                  productId: element.productId,
                  storeId: storeId,
                  country: country);
              if (item.id != null) {
                productList.add(item);
              }
            } catch (e) {
              log("Error fetching product from $storeId: ${e.toString()}");
            }
          }));
        }
      }

      // Run all fetch operations in parallel
      await Future.wait([
        fetchProducts(
            cartStoreList?.amazon, 'amazon', "US", productListFromAmazon),
        fetchProducts(
            cartStoreList?.taobao, 'taobao', "CN", productListFromTaobao),
        fetchProducts(
            cartStoreList?.lazada, 'lazada', "TH", productListFromLazada),
        fetchProducts(
            cartStoreList?.from1688, 'from1688', "CN", productListFromFrom1688),
        fetchProducts(
            cartStoreList?.fardin, 'fardin', "fardin", productListFromFardin),
        fetchProducts(cartStoreList?.amazonau, 'amazonau', "amazonau",
            productListFromAmazonau),
        fetchProducts(cartStoreList?.lazadavn, 'lazadavn', "lazadavn",
            productListFromLazadavn),
        fetchProducts(cartStoreList?.amazonfr, 'amazonfr', "amazonfr",
            productListFromAmazonfr),
        fetchProducts(cartStoreList?.amazonin, 'amazonin', "amazonin",
            productListFromAmazonin),
        fetchProducts(cartStoreList?.amazonit, 'amazonit', "amazonit",
            productListFromAmazonit),
        fetchProducts(cartStoreList?.amazonde, 'amazonde', "amazonde",
            productListFromAmazonde),
        fetchProducts(cartStoreList?.amazonae, 'amazonae', "amazonae",
            productListFromAmazonae),
        fetchProducts(cartStoreList?.amazonjp, 'amazonjp', "amazonjp",
            productListFromAmazonjp),
        fetchProducts(cartStoreList?.lazadath, 'lazadath', "lazadath",
            productListFromLazadath),
        fetchProducts(cartStoreList?.lazadasg, 'lazadasg', "lazadasg",
            productListFromLazadasg),
        fetchProducts(cartStoreList?.lazadaid, 'lazadaid', "lazadaid",
            productListFromLazadaid),
        fetchProducts(cartStoreList?.lazadamy, 'lazadamy', "lazadamy",
            productListFromLazadamy),
        fetchProducts(cartStoreList?.lazadaph, 'lazadaph', "lazadaph",
            productListFromLazadaph),
      ]);
    } catch (e) {
      log("getCartStoreList Error: ${e.toString()}");
    } finally {
      isLoading(false);
      update();
    }
  }

  ///note here
  // getCartStoreList() async {
  //   try {
  //     isLoading(true);
  //     // Clear productList to avoid duplication
  //     productListFromTaobao.clear();
  //     productListFromAmazon.clear();
  //     productListFromLazada.clear();
  //     productListFromFrom1688.clear();
  //     productListFromFardin.clear();
  //     productListFromAmazonau.clear();
  //     productListFromLazadavn.clear();
  //     productListFromAmazonfr.clear();
  //     productListFromAmazonin.clear();
  //     productListFromAmazonit.clear();
  //     productListFromAmazonde.clear();
  //     productListFromAmazonae.clear();
  //     productListFromAmazonjp.clear();
  //     productListFromLazadath.clear();
  //     productListFromLazadasg.clear();
  //     productListFromLazadaid.clear();
  //     productListFromLazadamy.clear();
  //     productListFromLazadaph.clear();
  //     update();

  //     // var tempCartStoreList = await _cartRepository.fetchCartStoreList();
  //     // cartStoreList = tempCartStoreList;
  //     cartStoreList = await _cartRepository.fetchCartStoreList();
  //     cartQty.value = cartStoreList?.taobao.length ?? 0;

  //     if (cartStoreList!.amazon.length > 0) {
  //       await Future.wait(cartStoreList!.amazon.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'amazon', country: "US")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromAmazon.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.taobao.length > 0) {
  //       // Fetch all product details in parallel
  //       await Future.wait(cartStoreList!.taobao.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId,
  //                   storeId: 'taobao',
  //                   country: "CN")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromTaobao.add(item);
  //             }
  //           })));

  //       // Filter out null results
  //       // productList.addAll(fetchedProducts.whereType<ProductModelRes>());
  //     }
  //     if (cartStoreList!.lazada.length > 0) {
  //       await Future.wait(cartStoreList!.lazada.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'lazada', country: "TH")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromLazada.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.from1688.length > 0) {
  //       await Future.wait(cartStoreList!.from1688.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'from1688', country: "CN")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromFrom1688.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.fardin.length > 0) {
  //       await Future.wait(cartStoreList!.fardin.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'fardin', country: "fardin")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromFardin.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.amazonau.length > 0) {
  //       await Future.wait(cartStoreList!.amazonau.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'amazonau', country: "AU")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromAmazonau.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.lazadavn.length > 0) {
  //       await Future.wait(cartStoreList!.lazadavn.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'lazadavn', country: "VN")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromLazadavn.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.amazonfr.length > 0) {
  //       await Future.wait(cartStoreList!.amazonfr.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'amazonfr', country: "FR")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromAmazonfr.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.amazonin.length > 0) {
  //       await Future.wait(cartStoreList!.amazonin.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'amazonin', country: "IN")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromAmazonin.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.amazonit.length > 0) {
  //       await Future.wait(cartStoreList!.amazonit.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'amazonit', country: "IT")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromAmazonit.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.amazonde.length > 0) {
  //       await Future.wait(cartStoreList!.amazonde.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'amazonde', country: "DE")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromAmazonde.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.amazonae.length > 0) {
  //       await Future.wait(cartStoreList!.amazonae.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'amazonae', country: "AE")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromAmazonae.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.amazonjp.length > 0) {
  //       await Future.wait(cartStoreList!.amazonjp.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'amazonjp', country: "JP")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromAmazonjp.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.lazadath.length > 0) {
  //       await Future.wait(cartStoreList!.lazadath.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'lazadath', country: "TH")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromLazadath.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.lazadasg.length > 0) {
  //       await Future.wait(cartStoreList!.lazadasg.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'lazadasg', country: "SG")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromLazadasg.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.lazadaid.length > 0) {
  //       await Future.wait(cartStoreList!.lazadaid.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'lazadaid', country: "ID")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromLazadaid.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.lazadamy.length > 0) {
  //       await Future.wait(cartStoreList!.lazadamy.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'lazadamy', country: "MY")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromLazadamy.add(item);
  //             }
  //           })));
  //     }
  //     if (cartStoreList!.lazadaph.length > 0) {
  //       await Future.wait(cartStoreList!.lazadaph.map((element) =>
  //           _productRepository
  //               .fetchProductDetails(
  //                   productId: element.productId, storeId: 'lazadaph', country: "PH")
  //               .then((item) {
  //             if (item.id != null) {
  //               productListFromLazadamy.add(item);
  //             }
  //           })));
  //     }

  //   } catch (e) {
  //     log(e.toString());
  //     // Optionally display a snackbar or some feedback for the user
  //     // showSnackBar("Exception", e.toString(), Colors.red);
  //   } finally {
  //     isLoading(false);
  //     update();
  //   }
  // }

  // getCartStoreList() async {
  //   isLoading(true);
  //   productList.clear(); // Clear productList to avoid duplication
  //   update();
  //   try {
  //     var tempCartStoreList = await _cartRepository.fetchCartStoreList();
  //     cartStoreList = tempCartStoreList;
  //     cartQty.value = cartStoreList?.taobao?.length ?? 0;

  //     ///note here
  //     if (cartStoreList?.taobao.isNotEmpty ?? false) {
  //       for (var element in cartStoreList!.taobao) {
  //         var productModel = await _productRepository.fetchProductDetails(
  //             productId: element.productId, storeId: 'taobao');
  //         // print("productModel: " + productModel.toString());
  //         // if (productModel != null) {
  //         //   productList.add(productModel);
  //         // }
  //       }
  //     }

  //     isLoading(false);
  //     update();
  //   } catch (e) {
  //     isLoading(false);
  //     update();
  //     log(e.toString());
  //     // Optionally display a snackbar or some feedback for the user
  //     // showSnackBar("Exception", e.toString(), Colors.red);
  //   }
  // }

  // getCartStoreList() async {
  //   try {
  //     isLoading(true);
  //     var tempCartStoreList = await _cartRepository.fetchCartStoreList();
  //     cartStoreList = tempCartStoreList;
  //     if (cartStoreList!.taobao.isNotEmpty) {
  //       cartQty.value = cartStoreList!.taobao.length;
  //       cartStoreList!.taobao.forEach((element) async {
  //         productModel = await _productRepository.fetchProductDetails(
  //             productId: element.productId);
  //         productList.add(productModel!);
  //         // print("productList: ${productList.length}");
  //       });
  //     }
  //     isLoading(false);
  //   } catch (e) {
  //     isLoading(false);
  //     // showSnackBar("Exception", e.toString(), Colors.red);
  //     log(e.toString());
  //   }
  // }

  void deleteItemFromCart(String productId, String cartId, String store) async {
    try {
      isLoading(true);
      await _cartRepository
          .removeCartItem(productId: productId, store: store, cartId: cartId)
          .then((resp) {
        if (resp.toString() == "Success") {
          isLoading(false);
          cartStoreList!.taobao.clear();
          // productList.clear();
          productListFromTaobao.clear();
          productListFromAmazon.clear();
          productListFromLazada.clear();
          productListFromFrom1688.clear();
          productListFromFardin.clear();
          productListFromAmazonau.clear();
          productListFromLazadavn.clear();
          productListFromAmazonfr.clear();
          productListFromAmazonin.clear();
          productListFromAmazonit.clear();
          productListFromAmazonde.clear();
          productListFromAmazonae.clear();
          productListFromAmazonjp.clear();
          productListFromLazadath.clear();
          productListFromLazadasg.clear();
          productListFromLazadaid.clear();
          productListFromLazadamy.clear();
          productListFromLazadaph.clear();

          getCartStoreList();
        } else {
          showSnackBar(
              "Cart", "Failed to remove product from cart", Colors.red);
        }
      }, onError: (err) {
        isLoading(false);
        showSnackBar("Error", err.toString(), Colors.blue);
      });
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void incrementCartItem(String productId) async {
    try {
      isLoading(true);
      await _cartRepository
          .putQuantity(productId: productId, quantity: "1")
          .then((resp) {
        if (resp.toString() == "success") {
          isLoading(false);
          // productList.clear();
          productListFromTaobao.clear();
          productListFromAmazon.clear();
          productListFromLazada.clear();
          productListFromFrom1688.clear();
          productListFromFardin.clear();
          productListFromAmazonau.clear();
          productListFromLazadavn.clear();
          productListFromAmazonfr.clear();
          productListFromAmazonin.clear();
          productListFromAmazonit.clear();
          productListFromAmazonde.clear();
          productListFromAmazonae.clear();
          productListFromAmazonjp.clear();
          productListFromLazadath.clear();
          productListFromLazadasg.clear();
          productListFromLazadaid.clear();
          productListFromLazadamy.clear();
          productListFromLazadaph.clear();
          getCartStoreList();
        } else {
          showSnackBar(
              "Cart", "Failed to remove product from cart", Colors.red);
        }
      }, onError: (err) {
        isLoading(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void decrementCartItem(String productId) async {
    try {
      isLoading(true);
      await _cartRepository
          .putQuantity(productId: productId, quantity: "-1")
          .then((resp) {
        if (resp.toString() == "success") {
          isLoading(false);
          // productList.clear();
          productListFromTaobao.clear();
          productListFromAmazon.clear();
          productListFromLazada.clear();
          productListFromFrom1688.clear();
          productListFromFardin.clear();
          productListFromAmazonau.clear();
          productListFromLazadavn.clear();
          productListFromAmazonfr.clear();
          productListFromAmazonin.clear();
          productListFromAmazonit.clear();
          productListFromAmazonde.clear();
          productListFromAmazonae.clear();
          productListFromAmazonjp.clear();
          productListFromLazadath.clear();
          productListFromLazadasg.clear();
          productListFromLazadaid.clear();
          productListFromLazadamy.clear();
          productListFromLazadaph.clear();
          getCartStoreList();
        } else {
          showSnackBar(
              "Cart", "Failed to remove product from cart", Colors.red);
        }
      }, onError: (err) {
        isLoading(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }
}
