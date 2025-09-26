import 'package:fardinexpress/features/my_order/controller/my_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MyOrderDetail extends StatefulWidget {
  final String orderId;
  const MyOrderDetail({Key? key, required this.orderId}) : super(key: key);
  @override
  State<MyOrderDetail> createState() => _MyOrderDetailState();
}

class _MyOrderDetailState extends State<MyOrderDetail> {
  final _controller = Get.put(MyOrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.instance
      ..backgroundColor = Colors.black.withOpacity(0.3)
      ..textColor = Colors.white;
    _controller.initMyOrderDetail(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      // appBar: AppBar(
      //   title: Text('orderDetails'.tr),
      // ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4CAF50), // Top: Medium green (Material Green 500)
                  Color.fromARGB(255, 147, 201,
                      150), // Bottom: Light green (Material Green 300)
                  Color.fromARGB(255, 175, 201, 176),
                ],
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                    title: Text('orderDetails'.tr,
                        style: TextStyle(color: Colors.white)),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.network(
                            '${"https://delivery.anakutapp.com/assets/uploads/"}' +
                                _controller
                                    .orderDetailModel!.warehouseDetail.map
                                    .toString(),
                            width: 40,
                            // height: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          // Icon(Icons.storefront_outlined,
                          //     size: 18, color: Colors.grey[700]),
                          Text(
                            " ${_controller.orderDetailModel!.warehouseDetail.name.toString().toUpperCase()} ",
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          // Icon(Icons.arrow_forward_ios_rounded,
                          //     size: 15, color: Colors.black),
                        ],
                      ),
                      SizedBox(height: 12),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              _controller.orderDetailModel!.itemDetail.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Image.network(
                                          _controller.orderDetailModel!
                                                  .itemDetail[index].image
                                                  .contains('http')
                                              ? '${_controller.orderDetailModel!.itemDetail[index].image}'
                                              : 'http${_controller.orderDetailModel!.itemDetail[index].image}', // Replace with actual image URL
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        // color: Colors.red,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${_controller.orderDetailModel!.itemDetail[index].name}',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[800]),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'qty'.tr +
                                                      ': ${_controller.orderDetailModel!.itemDetail[index].qty}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  '\$ ${_controller.orderDetailModel!.itemDetail[index].price.toString()}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            );
                          })
                    ],
                  ),
                ),
                // ListTile(
                //   leading: Image.network(
                //     'http://system.anakutapp.com/assets/uploads/17295136415757029682024122721PM.png', // Replace with actual image URL
                //     width: 60,
                //     height: 60,
                //     fit: BoxFit.cover,
                //   ),
                //   title: Text('รองเท้าหัวโต รองเท้า...', maxLines: 1),
                //   subtitle: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text('Brown, 8'),
                //       SizedBox(height: 4),
                //       Text(
                //         'Free Returns',
                //         style: TextStyle(color: Colors.blue),
                //       ),
                //     ],
                //   ),
                //   // trailing: Text('฿212.00'),
                // ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'orderSummary'.tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('orderId'.tr),
                            Row(
                              children: [
                                Text(
                                  '# ${_controller.orderDetailModel!.id}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              '# ${_controller.orderDetailModel!.id}'));
                                      EasyLoading.showToast('copied'.tr);
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      color: Colors.blue,
                                    ))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('របៀបដឹកជញ្ជួន'.tr),
                            Text(''),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('orderDate'.tr),
                            Text('${_controller.orderDetailModel!.date}'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('subTotal'.tr),
                            Text('\$ ${_controller.orderDetailModel!.total}'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('shippingFee'.tr),
                            Text(
                                '\$ ${_controller.orderDetailModel!.shippingFee}'),
                          ],
                        ),
                        // SizedBox(height: 8),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('Online Payment Discount'),
                        //     Text('-฿7.08'),
                        //   ],
                        // ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'total'.tr,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$ ${_controller.orderDetailModel!.total}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ]),
                ),

                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'paidBy'.tr,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment methods'.tr),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.orange[900],
                              ),
                              child: Text(
                                  '${_controller.orderDetailModel!.paymentType}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ]),
                )
              ],
            ),
          );
        }
      }),
    );
  }
}
