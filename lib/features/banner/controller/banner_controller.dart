import 'package:fardinexpress/features/banner/controller/banner_repository.dart';
import 'package:fardinexpress/features/banner/model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  var isLoading = false.obs;
  // var currentIndex = 0.obs;
  List<BannerModel> bannerList = <BannerModel>[].obs;
  BannerRepository bannerRepository = BannerRepository();

  BannerController() {
    getBannerList();
  }

  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  void getBannerList() async {
    try {
      isLoading(true);
      var tempBanners = await bannerRepository.getBannerImages();
      bannerList.addAll(tempBanners);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }
}
