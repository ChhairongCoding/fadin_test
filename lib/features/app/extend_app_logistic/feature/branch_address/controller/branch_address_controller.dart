import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/controller/branch_address_repository.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/model/countries_model.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/model/district_model.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/model/province_model.dart';
import 'package:get/get.dart';

// ProductController productController = ProductController();

class BranchAddressController extends GetxController {
  var isLoading = false.obs;
  // var currentIndex = 0.obs;
  List<ProvinceModel> branchAddressList = <ProvinceModel>[].obs;
  List<DistrictModel> districtList = <DistrictModel>[].obs;
  List<CountriesModel> countryList = <CountriesModel>[].obs;
  BranchAddressRepository branchAddressRepository = BranchAddressRepository();

  BranchAddressController() {
    getBranchAddressList();
    getCountryList();
  }

  void getBranchAddressList() async {
    try {
      isLoading(true);
      var tempList = await branchAddressRepository.fetchProvinceList();
      branchAddressList.addAll(tempList);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void getDistrictList(String? id) async {
    try {
      isLoading(true);
      var tempList = await branchAddressRepository.fetchDistrictList(id!);
      districtList.addAll(tempList);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void getCountryList() async {
    try {
      isLoading(true);
      var tempList = await branchAddressRepository.fetchCountryList();
      countryList.addAll(tempList);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
