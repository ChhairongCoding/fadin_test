import 'package:fardinexpress/features/category/controller/category_repository.dart';
import 'package:fardinexpress/features/category/model/categories_model.dart';
import 'package:fardinexpress/features/category/model/sub_categories_model.dart';
import 'package:get/get.dart';

// ProductController productController = ProductController();

class CategoryController extends GetxController {
  var isLoading = false.obs;
  // var currentIndex = 0.obs;
  List<CategoryModel> categories = <CategoryModel>[].obs;
  List<CategoryModel> backupCategories = <CategoryModel>[].obs;
  CategoryRepository categoryRepository = CategoryRepository();
  List<SubCategoryModel> subCategories =
      <SubCategoryModel>[].obs; // <SubCategoryModel>
  var selectedCategory = 0.obs;
  // static String? catId;
  // CategoryController({required this.catId});

  @override
  void onInit() {
    super.onInit();
    // getCategories();
    // getCategories().then((value) {
    //   if (categories.isNotEmpty) {
    //     backupCategories.addAll(categories);
    //     // selectedCategory.value = 0; // Default to the first category
    //     getSubCategories(categories[selectedCategory.value].id.toString());
    //   }
    // });
    // // Listen to category selection changes
    // selectedCategory.listen((index) {
    //   if (categories.isNotEmpty) {
    //     getSubCategories(categories[index].id.toString());
    //   }
    // });
  }

  Future<void> initCategory() async {
    getCategories().then((value) {
      if (categories.isNotEmpty) {
        backupCategories.addAll(categories);
        // selectedCategory.value = 0; // Default to the first category
        getSubCategories(categories[selectedCategory.value].id.toString());
      }
    });
    // Listen to category selection changes
  }

  Future<void> initSubCategory() async {
    selectedCategory.listen((index) {
      // subCategories.clear();
      if (categories.isNotEmpty) {
        // subCategories.clear();
        getSubCategories(categories[index].id.toString());
      }
    });
  }

  // CategoryController() {
  //   getCategories().then((value) {
  //     Future.delayed(Duration(seconds: 1));
  //     getSubCategories(categories[0].id.toString());
  //   });
  // }

  Future<void> getCategories() async {
    try {
      isLoading(true);
      var tempCategories = await categoryRepository.fetchCategoryList();
      categories.addAll(tempCategories);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void getSubCategories(String categoryId) async {
    try {
      subCategories.clear();
      isLoading(true);
      var tempSubCategories =
          await categoryRepository.fetchSubCategoryList(categoryId);
      subCategories.addAll(tempSubCategories);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
