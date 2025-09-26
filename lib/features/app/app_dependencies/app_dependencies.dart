import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/banner/controller/banner_controller.dart';
import 'package:fardinexpress/features/cart/controller/cart_store_controller.dart';
import 'package:fardinexpress/features/language/model/app_localization.dart';
import 'package:fardinexpress/features/payment/controller/paymet_control_index_controller.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/taxi/controller/taxi_controller.dart';
import 'package:get/get.dart';

class AppDependencies {
  static Future<void> init() async {
    Get.lazyPut(() => CartStoreController());
    Get.lazyPut(() => BannerController());
    Get.lazyPut(() => AccountController());
    Get.lazyPut(() => PaymentControlIndexController());
    Get.lazyPut(() => AppLocalization());
    // Get.lazyPut(() => TaxiController());
    Get.lazyPut(() => ProductController());
    Get.lazyPut(() => TaxiController());
  }
}
