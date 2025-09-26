import 'package:fardinexpress/features/cart/controller/add_to_cart_repository.dart';
import 'package:fardinexpress/features/cart/controller/cart_store_controller.dart';
import 'package:fardinexpress/features/cart/view/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddToCartController extends GetxController {
  AddToCartRepository addToCartRepository = AddToCartRepository();
  var isLoading = false.obs;
  var rpMessage;

  @override
  void onInit() {
    super.onInit();
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.green // Set your custom background color here
      ..indicatorColor = Colors.white // Customize indicator color
      ..textColor = Colors.white // Customize text color
      ..maskColor = Colors.black.withOpacity(0.5) // Customize mask color
      ..userInteractions = false; // Prevent user interactions while loading
  }

  // common snack bar
  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  void addProductToCart(
      String productId, String quantity, String storeId, String buyType) async {
    try {
      isLoading(true);
      await addToCartRepository
          .addToCart(productId: productId, quantity: quantity, storeId: storeId)
          .then((resp) {
        if (resp.toString() == "success") {
          isLoading(false);
          Get.find<CartStoreController>().productListFromTaobao.clear();
          Get.find<CartStoreController>().productListFromAmazon.clear();
          Get.find<CartStoreController>().productListFromLazada.clear();
          Get.find<CartStoreController>().productListFromFrom1688.clear();
          Get.find<CartStoreController>().productListFromFardin.clear();
          Get.find<CartStoreController>().getCartStoreList();
          if (buyType == "buynow") {
            Get.to(() => CartPage());
          } else {
            EasyLoading.showSuccess(
              'Cart added Success!',
              duration: Duration(seconds: 2),
            );
          }
        } else {
          showSnackBar("Cart", "Failed to added product to cart", Colors.red);
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

// void saveTask(Map data) {
//   try {
//     isProcessing(true);
//     TaskProvider().saveTask(data).then((resp) {
//       if (resp == "success") {
//         clearTextEditingControllers();
//         isProcessing(false);

//         showSnackBar("Add Task", "Task Added", Colors.green);
//         lstTask.clear();
//         refreshList();
//       } else {
//         showSnackBar("Add Task", "Failed to Add Task", Colors.red);
//       }
//     }, onError: (err) {
//       isProcessing(false);
//       showSnackBar("Error", err.toString(), Colors.red);
//     });
//   } catch (exception) {
//     isProcessing(false);
//     showSnackBar("Exception", exception.toString(), Colors.red);
//   }
// }
