import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/screens/widgets/delivery_detail_f1.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/screens/widgets/delivery_detail_status.dart';
import 'package:fardinexpress/shared/bloc/widget_info/widget_info_bloc.dart';
import 'package:flutter/material.dart';
import 'widgets/delivery_detail_f2.dart';
import 'widgets/tracking.dart';

class DeliveryDetailPage extends StatefulWidget {
  final bool arrivedLocal;
  final Delivery delivery;
  DeliveryDetailPage({required this.delivery, required this.arrivedLocal});
  @override
  _DeliveryDetailPageState createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  final WidgetInfoBloc widgetInfoBloc = WidgetInfoBloc();
  // DeliveryBloc deliveryBloc = DeliveryBloc();
  late Delivery delivery;
  @override
  void initState() {
    setState(() {
      delivery = widget.delivery;
    });
    super.initState();
  }

  @override
  void dispose() {
    // deliveryBloc.close();
    widgetInfoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context).pop(delivery);
          },
        ),
        title: new Text(
          "Shipping Detail",
          // "ពត៍មានលម្អិតអំពីការដឹកជញ្ជូន",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Container(
          //     color: Theme.of(context).primaryColor,
          //     child: DeliveryDetailStatus()),
          Container(
              color: Theme.of(context).primaryColor,
              height: 150,
              width: double.infinity),
          SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10),
                DeliveryDetailStatus(
                  delivery: delivery,
                ),
                SizedBox(height: 15),
                DeliveryDetailF1(
                  deliver: delivery,
                ),
                // (delivery.status.toLowerCase() == "completed" ||
                //         widget.arrivedLocal == false ||
                //         delivery.requestedDelivery)
                //     ? Center()
                //     : Container(
                //         width: double.infinity,
                //         margin: EdgeInsets.only(top: 15),
                //         child: BlocProvider(
                //             create: (c) => deliveryBloc,
                //             child: BtnDelivery(deliveryId: delivery.id))),

                // SizedBox(height: 15),
                // (delivery.requestedDeliveryAddress == null)
                //     ? Center()
                //     : Container(
                //         margin: EdgeInsets.only(top: 15),
                //         child: DeliveryAddress(
                //             address: delivery.requestedDeliveryAddress!)),
                // (delivery.driver == null)
                //     ? Center()
                //     : Container(
                //         margin: EdgeInsets.only(top: 15),
                //         child: DriverInfoTile(driver: delivery.driver!)),
                SizedBox(height: 15),
                DeliveryDetailF2(
                  delivery: delivery,
                ),
                SizedBox(height: 15),
                delivery.history.length == 0
                    ? Center()
                    : Tracking(history: delivery.history),
                SizedBox(height: 15.0),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
