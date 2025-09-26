import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/auth/login/view/auth_page.dart';
import 'package:fardinexpress/features/product/model/product_model.dart';
import 'package:fardinexpress/features/product/view/widget/product_detail.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProductScrollHorizontal extends StatelessWidget {
  final ProductModel productModel;
  final String storeId;
  final String countryCode;
  ProductScrollHorizontal(
      {Key? key,
      required this.productModel,
      required this.storeId,
      required this.countryCode})
      : super(key: key);
  final ApiProvider apiProvider = ApiProvider();

  @override
  Widget build(BuildContext context) {
    // var pName = apiProvider.gTranslate(keyword: productModel.name.toString());
    return GestureDetector(
      onTap: () {
        if (BlocProvider.of<AuthenticationBloc>(context).state
            is Authenticated) {
          Get.to(() => ProductDetailPageWrapper(
                // name: productModel.name!,
                // price: productModel.price!,
                // image: productModel.image,
                // description: productModel.name!,
                // promotionPrice: productModel.price!,
                id: productModel.id!,
                storeId: this.storeId,
                // descriptionDetail: productModel.description,
                countryCode: countryCode,
              ));
        } else {
          Get.to(() => AuthPage(
                isLogin: true,
              ));
        }
      },
      child: Container(
        padding: EdgeInsets.only(right: 10.0),
        // color: Colors.red,
        child: AspectRatio(
          aspectRatio: 4 / 5.2,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[200]),
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          color: Colors.grey[350],
                        ),
                        margin: EdgeInsets.all(6.0),
                        child: ExtendedImage.network(
                          productModel.image.contains('https:') ||
                                  productModel.image.contains('http:')
                              ? productModel.image
                              : "https:" + productModel.image.toString(),
                          // errorWidget: Container(
                          //   padding: EdgeInsets.all(10),
                          //   child: Image.asset("assets/img/image-gallery.png"),
                          // ),
                          // assets/img/product-hint.jpg
                          cacheWidth: 300,
                          // cacheHeight: 400,
                          // enableMemoryCache: true,
                          clearMemoryCacheWhenDispose: true,
                          clearMemoryCacheIfFailed: false,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Container(
                          // padding: EdgeInsets.all(8.0),
                          // color: Colors.red,
                          child: Text(
                            productModel.name.toString(),
                            // textScaleFactor: 1.2,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(),
                        Text(
                          "${productModel.price!.toString()} \$",
                          maxLines: 1,
                          // textScaleFactor: 1.1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
