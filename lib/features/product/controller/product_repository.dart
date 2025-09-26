import 'package:dio/dio.dart';
import 'package:fardinexpress/features/product/model/product_model.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ProductRepository {
  ApiProvider apiProvider = ApiProvider();
  String url = "";
  ProductModel? productModel;

  Future<List<ProductModel>> fetchProductLists(
      {required int? page,
      required int rowPerPage,
      required String categoryName,
      required var categoryId,
      required String store,
      required String country}) async {
    try {
      url = store != "fardin"
          ? "${dotenv.env['baseWebUrl']}/api/$store?api=item_search&page=$page&page_size=$rowPerPage&start_price=NaN&sort=default&q=$categoryName&country=$country"
          : "${dotenv.env['baseWebUrl']}/api/$store?api=item_search&page=$page&page_size=$rowPerPage&start_price=NaN&sort=default&q=$categoryName&country=$country&cat_id=$categoryId";

      // "${dotenv.env['baseWebUrl']}/api/$store?api=item_search&q=$categoryName&page_size=$rowPerPage&page=$page&country=$country&cat_id=$categoryId";

      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data["result"];
        List<ProductModel> productListing = <ProductModel>[].obs;
        data["item"].forEach((product) {
          productListing.add(ProductModel(
            id: product["num_iid"].toString(),
            // code: product["code"].toString(),
            name: product["title"].toString(),
            price: product["price"].toString(),
            image: product["pic"].toString(),
            description: product["description"].toString(),
          ));
        });
        return productListing;
      } else {
        var data = response.data;
        throw data["message"];
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<ProductModel>> searchProductLists(
      {required int? page,
      required int rowPerPage,
      required String query}) async {
    try {
      url =
          "${dotenv.env['baseWebUrl']}/api/taobao?api=item_search&page=$page&page_size=$rowPerPage&start_price=NaN&sort=default&q=$query";
      // "${dotenv.env['baseUrl']}/products?row_per_page=$rowPerPage&page=$page&name=$query&vendor_code=${dotenv.env['vendor_code']}";
      // log(url.toString());
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        // List<ProductModel> productListing = [];
        // response.data["data"].forEach((val) {
        //   productListing.add(ProductModel.fromJson(val));
        // });
        var data = response.data["result"];
        // log(data.toString());
        List<ProductModel> productListing = <ProductModel>[].obs;
        // List<ProductModel> productListing = [];
        data["item"].forEach((product) {
          // List<Photos> listPhoto = [];
          // product["photos"].forEach((photo) {
          //   listPhoto.add(Photos(
          //       id: photo["id"],
          //       productId: photo["product_id"],
          //       photo: photo["photo"].toString()));
          // });
          // List<VariantOptionType> listType = [];
          // product["variant_option_type"].forEach((type) {
          //   List<VariantOptionTypeData> listTypeData = [];
          //   type["data"].forEach((typeData) {
          //     listTypeData.add(VariantOptionTypeData(
          //         id: typeData["id"],
          //         name: typeData["name"].toString(),
          //         variantPrice: typeData["price"].toString()));
          //   });
          //   listType.add(VariantOptionType(
          //       id: type["id"],
          //       type: type["type"].toString(),
          //       variantOptionTypeDataList: listTypeData));
          // });
          // List<OptionalList> optionalList = [];
          // product["optional"].forEach((optionals) {
          //   List<OptionalTypeList> optionalTypeList = [];
          //   optionals["data"].forEach((typeData) {
          //     optionalTypeList.add(OptionalTypeList(
          //         id: typeData["id"],
          //         name: typeData["name"].toString(),
          //         optionalPrice: typeData["price"].toString()));
          //   });
          //   optionalList.add(OptionalList(
          //       id: optionals["id"],
          //       type: optionals["type"],
          //       optionalTypeList: optionalTypeList));
          // });
          productListing.add(ProductModel(
            id: product["num_iid"].toString(),
            // code: product["code"].toString(),
            name: product["title"].toString(),
            price: product["price"].toString(),
            image: product["pic"].toString(),
            description: product["description"].toString(),
            // description: product["product_details"].toString(),
            // storeName: product["store"].toString(),
            // storePhone: product["store_phone"].toString(),
            // storeId: product["store_id"].toString()
            // photos: listPhoto,
            // variantOptionTypeList: listType,
            // optional: optionalList
          ));
        });
        return productListing;
      } else {
        var data = response.data;
        throw data["message"];
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<ProductModel>> fetchProductListsByStore(
      {required int? page,
      required int rowPerPage,
      required String categoryName,
      required String categoryId,
      required String storeId,
      required String type,
      required String query,
      required String country,
      required String sort}) async {
    try {
      String subParam = '';
      // if (storeId == 'fardin') {
      //   subParam = '&cat_id=$categoryId';
      // } else {
      //   subParam = '';
      // }
      url = (type == 'render')
          ? "${dotenv.env['baseWebUrl']}/api/$storeId?api=item_search&page=$page&page_size=$rowPerPage&start_price=NaN&sort=$sort&q=$categoryName&country=$country$subParam"
          : "${dotenv.env['baseWebUrl']}/api/$storeId?api=item_search&page=$page&page_size=$rowPerPage&start_price=NaN&sort=default&q=$query&country=$country$subParam";
      print("url:" + url + "type:" + type);
      // (type == 'render')
      //     ? "${dotenv.env['baseUrl']}/products?row_per_page=$rowPerPage&page=$page&category_id=$categoryId&store_id=$storeId&vendor_code=${dotenv.env['vendor_code']}"
      //     : "${dotenv.env['baseUrl']}/products?row_per_page=$rowPerPage&page=$page&category_id=$categoryId&store_id=$storeId&vendor_code=${dotenv.env['vendor_code']}&name=$query";
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data["result"];
        List<ProductModel> productListing = <ProductModel>[].obs;
        data["item"].forEach((product) {
          productListing.add(ProductModel(
            id: product["num_iid"].toString(),
            // code: product["code"].toString(),
            name: product["title"].toString(),
            price: product["price"].toString(),
            image: product["pic"].toString(),
            description: product["description"].toString(),
          ));
        });
        return productListing;
      } else {
        var data = response.data;
        throw data["message"];
      }
    } catch (e) {
      throw e;
    }
  }

  // Future<List<ProductModel>> fetchProductListsByStoreLocal(
  //     {required int? page,
  //     required int rowPerPage,
  //     required var categoryId,
  //     required String storeId,
  //     required String type,
  //     required String query,
  //     required String country,
  //     required String sort}) async {
  //   try {
  //     // url = (type == 'render')
  //     //     ? "https://fardinexpress.asia/api/$storeId?api=item_search&page=$page&page_size=$rowPerPage&start_price=NaN&sort=$sort&q=$categoryId&country=$country"
  //     //     : "https://fardinexpress.asia/api/$storeId?api=item_search&page=$page&page_size=$rowPerPage&start_price=NaN&sort=default&q=$query&country=$country";
  //     // print("url:" + url + "type:" + type);
  //     (type == 'render')
  //         ? "${dotenv.env['baseUrl']}/products?row_per_page=$rowPerPage&page=$page&category_id=$categoryId&store_id=$storeId&vendor_code=${dotenv.env['vendor_code']}"
  //         : "${dotenv.env['baseUrl']}/products?row_per_page=$rowPerPage&page=$page&category_id=$categoryId&store_id=$storeId&vendor_code=${dotenv.env['vendor_code']}&name=$query";

  //     // https://delivery.anakutapp.com/anakut/public/api/products?vendor_code=anakut_buy&store_id=42&row_per_page=12&page=1&name=office
  //     Response response = (await (apiProvider.get(url, null, null)))!;
  //     if (response.statusCode == 200) {
  //       List<ProductModel> productListing = [];
  //       response.data["data"].forEach((val) {
  //         productListing.add(ProductModel.fromJson(val));
  //       });
  //       var data = response.data["data"];
  //       // log(data["data"].length.toString());
  //       // log(url.toString());
  //       List<ProductModel> productListing = <ProductModel>[].obs;
  //       List<ProductModel> productListing = [];
  //       data["item"].forEach((product) {
  //         // List<Photos> listPhoto = [];
  //         // product["photos"].forEach((photo) {
  //         //   listPhoto.add(Photos(
  //         //       id: photo["id"],
  //         //       productId: photo["product_id"],
  //         //       photo: photo["photo"].toString()));
  //         // });
  //         // List<VariantOptionType> listType = [];
  //         // product["variant_option_type"].forEach((type) {
  //         //   List<VariantOptionTypeData> listTypeData = [];
  //         //   type["data"].forEach((typeData) {
  //         //     listTypeData.add(VariantOptionTypeData(
  //         //         id: typeData["id"],
  //         //         name: typeData["name"].toString(),
  //         //         variantPrice: typeData["price"].toString()));
  //         //   });
  //         //   listType.add(VariantOptionType(
  //         //       id: type["id"],
  //         //       type: type["type"].toString(),
  //         //       variantOptionTypeDataList: listTypeData));
  //         // });
  //         // List<OptionalList> optionalList = [];
  //         // product["optional"].forEach((optionals) {
  //         //   List<OptionalTypeList> optionalTypeList = [];
  //         //   optionals["data"].forEach((typeData) {
  //         //     optionalTypeList.add(OptionalTypeList(
  //         //         id: typeData["id"],
  //         //         name: typeData["name"].toString(),
  //         //         optionalPrice: typeData["price"].toString()));
  //         //   });
  //         //   optionalList.add(OptionalList(
  //         //       id: optionals["id"],
  //         //       type: optionals["type"],
  //         //       optionalTypeList: optionalTypeList));
  //         // });
  //         productListing.add(ProductModel(
  //           id: product["num_iid"].toString(),
  //           // code: product["code"].toString(),
  //           name: product["title"].toString(),
  //           price: product["price"].toString(),
  //           image: product["pic"].toString(),
  //           description: product["description"].toString(),
  //           // description: product["product_details"].toString(),
  //           // storeName: product["store"].toString(),
  //           // storePhone: product["store_phone"].toString(),
  //           // storeId: product["store_id"].toString()
  //           // photos: listPhoto,
  //           // variantOptionTypeList: listType,
  //           // optional: optionalList
  //         ));
  //       });
  //       return productListing;
  //     } else {
  //       var data = response.data;
  //       throw data["message"];
  //     }
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<ProductModelRes> fetchProductDetails(
      {required String productId,
      required String storeId,
      required String country}) async {
    try {
      url =
          "${dotenv.env['baseWebUrl']}/api/$storeId?api=item_detail_simple&num_iid=$productId&country=$country";
      // "https://fardinexpress.asia/api/$storeId?api=item_detail_simple&num_iid=$productId&country=$country";
      // "${dotenv.env['baseUrl']}/products?row_per_page=$rowPerPage&page=$page&name=$query&vendor_code=${dotenv.env['vendor_code']}";
      // log(url.toString());
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data["result"]["item"];
        // log(data.toString());
        return ProductModelRes.fromJson(data);
      } else {
        var data = response.data;
        throw data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ProductModelRes> fetchProductByUrl({required String webUrl}) async {
    try {
      url = "${dotenv.env['baseWebUrl']}/api/search_by_url?url=$webUrl";
      // "https://fardinexpress.asia/api/$storeId?api=item_detail_simple&num_iid=$productId&country=$country";
      // "${dotenv.env['baseUrl']}/products?row_per_page=$rowPerPage&page=$page&name=$query&vendor_code=${dotenv.env['vendor_code']}";
      // log(url.toString());
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data["result"]["item"];
        // log(data.toString());
        return ProductModelRes.fromJson(data);
      } else {
        var data = response.data;
        throw data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<ProductModel>> fetchProductByImage(
      {required String? imageUrl,
      required String store,
      required int page,
      required int rowPerPage}) async {
    try {
      url =
          "${dotenv.env['baseWebUrl']}/api/$store?api=image_search&image=$imageUrl&page=$page&page_size=$rowPerPage";
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data["result"];
        List<ProductModel> productListing = <ProductModel>[].obs;
        data["item"].forEach((product) {
          productListing.add(ProductModel(
            id: product["num_iid"].toString(),
            name: product["title"].toString(),
            price: product["price"].toString(),
            image: product["pic"].toString(),
            description: product["description"] == null
                ? ""
                : product["description"].toString(),
          ));
        });
        return productListing;
      } else {
        var data = response.data;
        throw data["message"];
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<ProductModel>> fetchSortProductsByPrice(
      {required int? page,
      required int rowPerPage,
      required var categoryId,
      required String storeId,
      required String startPrice,
      required String endPrice,
      required String country}) async {
    try {
      url =
          "${dotenv.env['baseWebUrl']}/api/$storeId?api=item_search&page=$page&page_size=$rowPerPage&start_price=$startPrice&end_price=$endPrice&sort=default&q=$categoryId&country=$country";
      // "https://fardinexpress.asia/api/taobao?api=item_search&page=1&page_size=25&start_price=10&end_price=12&sort=price_asc&q=Hardware%20Tools"
      // print("url:" + url + "type:" + type);
      // (type == 'render')
      //     ? "${dotenv.env['baseUrl']}/products?row_per_page=$rowPerPage&page=$page&category_id=$categoryId&store_id=$storeId&vendor_code=${dotenv.env['vendor_code']}"
      //     : "${dotenv.env['baseUrl']}/products?row_per_page=$rowPerPage&page=$page&category_id=$categoryId&store_id=$storeId&vendor_code=${dotenv.env['vendor_code']}&name=$query";
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data["result"];
        List<ProductModel> productListing = <ProductModel>[].obs;
        data["item"].forEach((product) {
          productListing.add(ProductModel(
            id: product["num_iid"].toString(),
            // code: product["code"].toString(),
            name: product["title"].toString(),
            price: product["price"].toString(),
            image: product["pic"].toString(),
            description: product["description"].toString(),
          ));
        });
        return productListing;
      } else {
        var data = response.data;
        throw data["message"];
      }
    } catch (e) {
      throw e;
    }
  }
}
