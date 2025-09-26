import 'package:fardinexpress/features/zone/controller/zone_repository.dart';
import 'package:fardinexpress/features/zone/model/zone_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneController extends GetxController {
  var isLoading = false.obs;
  // var currentIndex = 0.obs;
  RxList<ZoneModel> zoneList = <ZoneModel>[].obs;
  // RxList<ZoneModel> backupZoneList = <ZoneModel>[].obs;
  RxList<ZoneModel> filteredZoneList = <ZoneModel>[].obs;
  ZoneRepository _zoneRepository = ZoneRepository();
  var isMoreDataAvailable = true.obs;
  var isDataProcessing = false.obs;
  int page = 1;
  int rowPerPage = 500;
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  // ZoneController() {
  //   getZoneList();
  // }

  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  void getZoneList() async {
    try {
      if (isMoreDataAvailable(true) && zoneList.isNotEmpty) {
        zoneList.clear();
      }
      page = 1;
      isDataProcessing(true);
      await _zoneRepository.fetchZoneList(page, rowPerPage).then((value) async {
        isDataProcessing(false);
        zoneList.addAll(value);
      }, onError: (err) {
        isDataProcessing(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
      // isLoading(true);
      // var tempList = await _zoneRepository.fetchZoneList();
      // zoneList.addAll(tempList);
      // isLoading(false);
    } catch (e) {
      // isLoading(false);
      isDataProcessing(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  paginateZoneList() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreZoneList(page);
      }
    });
  }

  getMoreZoneList(var pages) async {
    try {
      await _zoneRepository.fetchZoneList(pages, rowPerPage).then(
          (value) async {
        if (value.length > rowPerPage) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
        }
        zoneList.addAll(value);
      }, onError: (err) {
        isMoreDataAvailable(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isMoreDataAvailable(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void filterZoneByName(String name) {
    try {
      if (name.isEmpty) {
        // If no name is provided, reset the filtered list to the original list
        filteredZoneList.assignAll(zoneList);
      } else {
        // Filter the zoneList by name
        filteredZoneList.assignAll(
          zoneList
              .where((zone) =>
                  zone.name.toLowerCase().contains(name.toLowerCase()))
              .toList(),
        );
      }
    } catch (e) {
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  // void searchZone(String query) {
  //   if (query.isEmpty) {
  //     // If the query is empty, reset to the original list
  //     backupZoneList.assignAll(zoneList);
  //   } else {
  //     // Perform a case-insensitive search
  //     backupZoneList.assignAll(zoneList.where((zone) =>
  //             zone.name.toLowerCase().contains(query.toLowerCase()) ||
  //             zone.id.toString().contains(query)) // Example fields: name or id
  //         );
  //   }
  // }

  // void getZoneList() async {
  //   try {
  //     isLoading(true);
  //     var tempList = await _zoneRepository.fetchZoneList();
  //     zoneList.addAll(tempList);
  //     isLoading(false);
  //   } catch (e) {
  //     isLoading(false);
  //     showSnackBar("Exception", e.toString(), Colors.red);
  //   }
  // }
}
