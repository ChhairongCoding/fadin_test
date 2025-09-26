import 'package:fardinexpress/features/shop/controller/store_repository.dart';
import 'package:fardinexpress/features/shop/model/shop_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class StoreController extends GetxController {
  var isLoading = false.obs;
  List<StoreModel> storeList = <StoreModel>[].obs;
  List<StoreModel> backupStoreList = <StoreModel>[].obs;
  StoreRepository storeRepository = StoreRepository();
  // RxString storeId = "taobao".obs;
  // RxString country = "CN".obs;
  RxString storeId = "fardin".obs;
  RxString country = "fardin".obs;
  RxString subCategoryId = "".obs;
  var selectedStore = 0.obs;
  var selectedStoreAllCategory = 0.obs;
  RxBool isRefresh = true.obs;

  // StoreController() {
  //   getStoreList();
  // }

  @override
  void onInit() {
    super.onInit();
    print("init store controller");
  }

  initStoreList() async {
    getStoreList(getStoreType: 'store_home').then((value) {
      if (storeList.isNotEmpty) {
        backupStoreList.addAll(storeList);
      }
    });
  }

  // getStoreType = {'store_home', store_list}
  getStoreList({required String getStoreType}) async {
    try {
      isLoading(true);

      storeList.clear();
      var tempStores = await storeRepository.fetchStoreList();
      // map data from tempStores to storeList where country = "fardin"
      // for (var element in tempStores) {
      //   if (element.country == "fardin") {
      //     selectedStore.value = tempStores.indexOf(element);
      //   }
      // }
      if (getStoreType == "store_home") {
        var filterStore =
            tempStores.where((element) => element.country == "fardin");
        selectedStore.value = tempStores.indexOf(filterStore.first);
      }
      storeList.addAll(tempStores);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}

//  storeList.clear();
//       var tempStores = await storeRepository.fetchStoreList();
//       // map data from tempStores to storeList where country = "fardin"
//       // for (var element in tempStores) {
//       //   if (element.country == "fardin") {
//       //     selectedStore.value = tempStores.indexOf(element);
//       //   }
//       // }
//       var filterStore =
//           tempStores.where((element) => element.country == "fardin");
//       selectedStore.value = tempStores.indexOf(filterStore.first);
//       storeList.addAll(tempStores);
//       // isLoading(false);
