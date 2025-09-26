import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/product/controller/product_controller.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail.dart';
import 'package:fardinexpress/features/shop/controller/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductListBySearch extends StatefulWidget {
  final String query;
  const ProductListBySearch({Key? key, required this.query}) : super(key: key);

  @override
  State<ProductListBySearch> createState() => _ProductListBySearchState();
}

class _ProductListBySearchState extends State<ProductListBySearch> {
  // ProductController? _productController;
  // final StoreController _storeController =
  //     Get.put(StoreController(), tag: "storeSearchCtr");

  Future<String?> resolveGoogleMapsShortLink(String shortUrl) async {
    try {
      final response = await http.get(
        Uri.parse(shortUrl),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      if (response.statusCode == 200) {
        // Return the final redirected URL
        final resolvedUrl = response.request?.url.toString();
        if (resolvedUrl != null) {
          return resolvedUrl;
        } else {
          print("Error: No redirected URL found in the response.");
          return null;
        }
      } else {
        print("Error: HTTP request failed with status ${response.statusCode}");
        return null;
      }
    } catch (e, stackTrace) {
      print("Error resolving URL: $e\nStack trace: $stackTrace");
      return null;
    }
  }

  Map<String, double>? extractLatLng(String url) {
    final RegExp regExp = RegExp(r'@?(-?\d+\.\d+),\s*(-?\d+\.\d+)');
    final match = regExp.firstMatch(url);

    if (match != null && match.groupCount >= 2) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null) {
        return {'lat': lat, 'lng': lng};
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _resolveUrlAndExtractCoords();
  }

  Future<void> _resolveUrlAndExtractCoords() async {
    final resolvedUrl = await resolveGoogleMapsShortLink(widget.query);
    if (resolvedUrl != null) {
      final coords = extractLatLng(resolvedUrl);
      if (coords != null) {
        print("Latitude: ${coords['lat']}, Longitude: ${coords['lng']}");
      } else {
        print("Coordinates not found in the resolved URL.");
      }
    } else {
      print("Could not resolve short URL.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // Obx(() {
    //   if (_productController!.isDataProcessing.value) {
    //     return Center(child: CircularProgressIndicator());
    //   } else if (_productController!.productList.isEmpty) {
    //     return Center(child: Text("No products found"));
    //   } else {
    //     return ListView(
    //       physics: NeverScrollableScrollPhysics(),
    //       children: [
    //         Container(
    //           margin: EdgeInsets.only(top: 10),
    //           height: 50,
    //           child: Obx(() {
    //             if (_storeController.isLoading.value) {
    //               return Center(child: CircularProgressIndicator());
    //             } else {
    //               return Container(
    //                   padding:
    //                       EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
    //                   child: ListView.builder(
    //                       shrinkWrap: true,
    //                       scrollDirection: Axis.horizontal,
    //                       // physics: NeverScrollableScrollPhysics(),
    //                       // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                       //     childAspectRatio: 4 / 2,
    //                       //     crossAxisCount: 2,
    //                       //     crossAxisSpacing: 5,
    //                       //     mainAxisSpacing: 5),
    //                       itemCount: _storeController.storeList.length,
    //                       itemBuilder: (context, index) {
    //                         return GestureDetector(
    //                           onTap: () {
    //                             _storeController.storeId.value =
    //                                 _storeController.storeList[index].id
    //                                     .toString();
    //                             _storeController.country.value =
    //                                 _storeController.storeList[index].country
    //                                     .toString();
    //                             _storeController.selectedStore.value = index;
    //                             _productController!
    //                                 .initSearchProduct(widget.query);
    //                             _productController!
    //                                 .paginateSearchProduct(widget.query);
    //                           },
    //                           child: Container(
    //                             padding:
    //                                 EdgeInsets.only(right: 10.0, left: 10.0),
    //                             decoration: BoxDecoration(
    //                               color: _storeController.selectedStore.value ==
    //                                       index
    //                                   ? Colors.green
    //                                   : Colors.white,
    //                               border: Border(
    //                                   right: BorderSide(color: Colors.grey)),
    //                             ),
    //                             child: ExtendedImage.network(
    //                               "${_storeController.storeList[index].image}",
    //                               // errorWidget:
    //                               //     Image.asset("assets/img/fardin-logo.png"),
    //                               cacheWidth: 200,
    //                               // cacheHeight: 50,
    //                               // enableMemoryCache: true,
    //                               clearMemoryCacheWhenDispose: true,
    //                               clearMemoryCacheIfFailed: false,
    //                               fit: BoxFit.cover,
    //                             ),
    //                           ),
    //                         );
    //                       }));
    //             }
    //           }),
    //         ),
    //         Container(
    //             padding: EdgeInsets.all(10.0),
    //             child: GridView.builder(
    //                 shrinkWrap: true,
    //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                     childAspectRatio: 4 / 5.5,
    //                     crossAxisCount: 2,
    //                     crossAxisSpacing: 8,
    //                     mainAxisSpacing: 8),
    //                 itemCount: _productController!.productList.length,
    //                 controller: _productController!.scrollController,
    //                 itemBuilder: (context, index) {
    //                   return GestureDetector(
    //                     onTap: () => Get.to(() => ProductDetailPageWrapper(
    //                           // name:
    //                           //     _productController!.productList[index].name!,
    //                           // price:
    //                           //     _productController!.productList[index].price!,
    //                           // image:
    //                           //     _productController!.productList[index].image,
    //                           // description:
    //                           //     _productController!.productList[index].name!,
    //                           // promotionPrice:
    //                           //     _productController!.productList[index].price!,
    //                           id: _productController!.productList[index].id!,
    //                           storeId: _storeController.storeList[index].id
    //                               .toString(),
    //                           // descriptionDetail: _productController!
    //                           //     .productList[index].description,
    //                           countryCode: _storeController.country.value,
    //                           // _productController!.productList[index].storeId!,
    //                         )),
    //                     child: AspectRatio(
    //                       aspectRatio: 5,
    //                       child: Container(
    //                           decoration: BoxDecoration(
    //                               borderRadius: BorderRadius.circular(12.0),
    //                               color: Colors.white),
    //                           child: Column(
    //                             children: [
    //                               Expanded(
    //                                 flex: 7,
    //                                 child: ClipRRect(
    //                                   borderRadius: BorderRadius.only(
    //                                       topLeft: Radius.circular(12.0),
    //                                       topRight: Radius.circular(12.0)),
    //                                   child: Container(
    //                                     decoration: BoxDecoration(
    //                                       borderRadius: BorderRadius.only(
    //                                           topLeft: Radius.circular(8.0),
    //                                           topRight: Radius.circular(8.0)),
    //                                       color: Colors.grey[350],
    //                                     ),
    //                                     margin: EdgeInsets.all(6.0),
    //                                     child: ExtendedImage.network(
    //                                       "https:" +
    //                                           _productController!
    //                                               .productList[index].image,
    //                                       // errorWidget: Container(
    //                                       //   child: Image.asset(
    //                                       //       "assets/img/image-gallery.png"),
    //                                       // ),
    //                                       cacheWidth: 400,
    //                                       // cacheHeight: 400,
    //                                       // enableMemoryCache: true,
    //                                       clearMemoryCacheWhenDispose: true,
    //                                       clearMemoryCacheIfFailed: false,
    //                                       fit: BoxFit.cover,
    //                                       width: double.infinity,
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 flex: 4,
    //                                 child: Column(
    //                                   children: [
    //                                     Container(
    //                                       padding: EdgeInsets.symmetric(
    //                                           horizontal: 8.0),
    //                                       // color: Colors.red,
    //                                       child: Text(
    //                                         _productController!
    //                                             .productList[index].name!
    //                                             .toString(),
    //                                         textScaleFactor: 1.2,
    //                                         maxLines: 2,
    //                                         textAlign: TextAlign.center,
    //                                       ),
    //                                     ),
    //                                     SizedBox(),
    //                                     Text(
    //                                       "${_productController!.productList[index].price!} \$",
    //                                       maxLines: 1,
    //                                       textScaleFactor: 1.1,
    //                                       textAlign: TextAlign.center,
    //                                       style: TextStyle(
    //                                           color: Colors.redAccent,
    //                                           fontWeight: FontWeight.bold),
    //                                     )
    //                                   ],
    //                                 ),
    //                               )
    //                             ],
    //                           )),
    //                     ),
    //                   );
    //                 })),
    //       ],
    //     );
    //   }
    // });
  }
}
