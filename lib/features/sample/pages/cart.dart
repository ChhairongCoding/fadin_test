import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/cart/controller/cart_store_controller.dart';
import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:fardinexpress/features/checkout/view/checkout_page.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItem extends StatefulWidget {
  CartItem({Key? key}) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  CartStoreController _cartStoreController = Get.find<CartStoreController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_cartStoreController.isLoading.value == true) {
          return Center(child: CircularProgressIndicator());
        }
        if (_cartStoreController.cartQty.value == 0) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.width / 3.5,
                  child: FittedBox(
                      child: Icon(Icons.shopping_cart_outlined,
                          color: Colors.grey[300]))),
              SizedBox(height: 20),
              Text(
                "cartEmpty".tr,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ));
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              _cartStoreController.cartStoreList!.taobao.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.taobao,
                      _cartStoreController.productListFromTaobao,
                      context,
                      "China"),
              _cartStoreController.cartStoreList!.amazon.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.amazon,
                      _cartStoreController.productListFromAmazon,
                      context,
                      "Amazon US"),
              _cartStoreController.cartStoreList!.lazada.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.lazada,
                      _cartStoreController.productListFromLazada,
                      context,
                      "Thailand"),
              _cartStoreController.cartStoreList!.fardin.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.fardin,
                      _cartStoreController.productListFromFardin,
                      context,
                      "Cambodia"),
              _cartStoreController.cartStoreList!.from1688.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.from1688,
                      _cartStoreController.productListFromFrom1688,
                      context,
                      "1688 China"),
              _cartStoreController.cartStoreList!.amazonau.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.amazonau,
                      _cartStoreController.productListFromAmazonau,
                      context,
                      "Amazon Australia"),
              _cartStoreController.cartStoreList!.lazadavn.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.lazadavn,
                      _cartStoreController.productListFromLazadavn,
                      context,
                      "Lazada Vietnam"),
              _cartStoreController.cartStoreList!.amazonfr.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.amazonfr,
                      _cartStoreController.productListFromAmazonfr,
                      context,
                      "Amazon Franche"),
              _cartStoreController.cartStoreList!.amazonin.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.amazonin,
                      _cartStoreController.productListFromAmazonin,
                      context,
                      "Amazon India"),
              _cartStoreController.cartStoreList!.amazonit.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.amazonit,
                      _cartStoreController.productListFromAmazonit,
                      context,
                      "Amazon Italy"),
              _cartStoreController.cartStoreList!.amazonde.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.amazonde,
                      _cartStoreController.productListFromAmazonde,
                      context,
                      "Amazon Germany"),
              _cartStoreController.cartStoreList!.amazonae.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.amazonae,
                      _cartStoreController.productListFromAmazonae,
                      context,
                      "Amazon Arab Emirates"),
              _cartStoreController.cartStoreList!.amazonjp.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.amazonjp,
                      _cartStoreController.productListFromAmazonjp,
                      context,
                      "Amazon japan"),
              _cartStoreController.cartStoreList!.lazadath.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.lazadath,
                      _cartStoreController.productListFromLazadath,
                      context,
                      "Lazada Thailand"),
              _cartStoreController.cartStoreList!.lazadasg.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.lazadasg,
                      _cartStoreController.productListFromLazadasg,
                      context,
                      "Lazada Singapore"),
              _cartStoreController.cartStoreList!.lazadaid.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.lazadaid,
                      _cartStoreController.productListFromLazadaid,
                      context,
                      "Lazada Indonesia"),
              _cartStoreController.cartStoreList!.lazadamy.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.lazadamy,
                      _cartStoreController.productListFromLazadamy,
                      context,
                      "Lazada Malaysia"),
              _cartStoreController.cartStoreList!.lazadaph.isEmpty
                  ? Container()
                  : _buildCartItem(
                      _cartStoreController.cartStoreList!.lazadaph,
                      _cartStoreController.productListFromLazadaph,
                      context,
                      "Lazada Philippines"),
              // _buildCartItem(_cartStoreController.cartStoreList!,
              //     _cartStoreController.productList, context),
            ],
          ),
        );
        // ListView.builder(
        //     itemCount: _cartStoreController.cartStoreList.length,
        //     itemBuilder: (context, index) {
        //       return _buildCartItem(
        //           _cartStoreController.cartStoreList[index], context);
        //     });
      },
    );
  }

  Widget _buildCartItem(List<CartStoreItem> cartStoreModel,
      List<ProductModelRes> products, var _, String storeName) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 9,
                    child: Text(
                      "${storeName}",
                      textScaleFactor: 1.2,
                      maxLines: 1,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, i) => Card(
                elevation: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        // width: 100,
                        aspectRatio: 1,
                        child: products[i].image!.isEmpty
                            ? Container(
                                child: Opacity(
                                    opacity: 0.5,
                                    child: Image.asset(
                                        "assets/img/image-gallery.png")),
                              )
                            : ExtendedImage.network(
                                // "assets/img/image-gallery.png",
                                products[i]
                                        .image![0]
                                        .toString()
                                        .contains("http")
                                    ? products[i].image![0].toString()
                                    : "http:${products[i].image![0]}",
                                // errorWidget: Container(
                                //   child: Opacity(
                                //       opacity: 0.5,
                                //       child: Image.asset(
                                //           "assets/img/fardin-logo-hint.png")),
                                // ),
                                // cacheWidth: 500,
                                // cacheHeight: 400,
                                // enableMemoryCache: true,
                                clearMemoryCacheWhenDispose: true,
                                clearMemoryCacheIfFailed: false,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[i].name!.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Expanded(
                            //   child: Text(
                            //     "Description",
                            //     maxLines: 2,
                            //     overflow: TextOverflow.ellipsis,
                            //   ),
                            // ),
                            Text(
                              "${products[i].price}\$",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (_cartStoreController.isLoading.value ==
                                  false) {
                                _cartStoreController.deleteItemFromCart(
                                    products[i].id.toString(),
                                    cartStoreModel[i].id.toString(),
                                    cartStoreModel[i].type.toString());
                              }
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.redAccent,
                            )),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(2.0)),
                              child: IconButton(
                                  onPressed: () {
                                    ///note here
                                    // if (cartStoreModel[i].quantity > 1) {
                                    //   _cartStoreController.decrementCartItem(
                                    //       cartStoreModel[i].id.toString());
                                    // }
                                    if (_cartStoreController.isLoading.value ==
                                            false &&
                                        cartStoreModel[i].quantity > 1) {
                                      _cartStoreController.decrementCartItem(
                                          cartStoreModel[i].id.toString());
                                    }
                                    if (cartStoreModel[i].quantity == 1 &&
                                        _cartStoreController.isLoading.value ==
                                            false) {
                                      // _cartStoreController.deleteItemFromCart(
                                      //     _cartStoreController.productList[i].id
                                      //         .toString(),
                                      //     cartStoreModel.amazon[i].id
                                      //         .toString(),
                                      //     cartStoreModel.amazon[i].type
                                      //         .toString());

                                      _cartStoreController.deleteItemFromCart(
                                          products[i].id.toString(),
                                          cartStoreModel[i].id.toString(),
                                          cartStoreModel[i].type.toString());
                                    }
                                  },
                                  icon: Icon(Icons.remove)),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 0.0),
                              child:
                                  Text(cartStoreModel[i].quantity.toString()),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(2.0)),
                              child: IconButton(
                                  onPressed: () {
                                    if (_cartStoreController.isLoading.value ==
                                        false) {
                                      _cartStoreController.incrementCartItem(
                                          cartStoreModel[i].id.toString());
                                    }
                                  },
                                  icon: Icon(Icons.add)),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          _buildBottom(cartStoreModel, products, _)
        ],
      ),
    );
  }

  Widget _buildBottom(List<CartStoreItem> cartStoreModel,
      List<ProductModelRes> products, var _) {
    double subTotal = 0.0;
    // for (var i = 0; i < products.length; i++) {
    //   if (products[i].price != null && cartStoreModel.amazon != []) {
    //     double price = double.parse(products[i].price!.toString());
    //     subTotal += price * cartStoreModel.amazon[i].quantity;
    //   }
    // }

    for (var i = 0; i < products.length; i++) {
      double price = double.parse(products[i].price!.toString());
      subTotal += price * cartStoreModel[i].quantity;
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16,
        bottom: 8.0,
        top: 4.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "subTotal".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$ ${subTotal.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    "Subtotal does not include shipping",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16.0,
                    ),
                    backgroundColor: Theme.of(_).primaryColor.withOpacity(0.8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // side: BorderSide(
                      //   color: Colors.black38,
                      // ),
                    ),
                  ),
                  onPressed: () => Get.to(() => CheckoutPage(
                        cartStoreModel: cartStoreModel,
                        productList: products,
                        total: subTotal.toStringAsFixed(2).toString(),
                        countryId: cartStoreModel[0].country_id.toString(),
                      )),
                  child: Text(
                    "checkout".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 16),
          // Text("Continue shopping"),
        ],
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Cart",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
      ],
      iconTheme: IconThemeData(color: Colors.black),
    );
  }
}
