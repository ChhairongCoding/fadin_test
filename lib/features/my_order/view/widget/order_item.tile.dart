import 'package:fardinexpress/features/my_order/model/order_model.dart';
import 'package:fardinexpress/features/my_order/view/my_order_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderItemTile extends StatelessWidget {
  final OrderModel orderModel;
  const OrderItemTile({Key? key, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MyOrderDetail(
              orderId: orderModel.id!.toString(),
            ));
        // Navigator.pushNamed(context, orderDetail, arguments: myOrder.id);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => OrderDetailPage(
        //             accessToken: accessToken,
        //             orderId: myOrder.id,
        //           )),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon(Icons.storefront_outlined,
                  //     size: 18, color: Colors.grey[700]),
                  Image.network(
                    '${"https://delivery.anakutapp.com/assets/uploads/"}' +
                        this.orderModel.warehouseDetail.map.toString(),
                    width: 40,
                    // height: 50,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Text(
                    " ${this.orderModel.warehouseDetail.name} ",
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 15, color: Colors.black),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Order Id: ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text("#${orderModel.id.toString()}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Total: ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(orderModel.total.toString(),
                      style: TextStyle(color: Colors.red[300])),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Date: ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(orderModel.date.toString(),
                      style: TextStyle(color: Colors.black)),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Address: ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Flexible(
                    child: Text(orderModel.address.toString(),
                        overflow: TextOverflow.visible,
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Status: ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(orderModel.status.toString(),
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
