import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/bloc/price_estimation_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/bloc/price_estimation_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/bloc/price_estimation_state.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/estimation.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/screens/widgets/country.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/bloc/warehouse_address_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/custom_dialog.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/error_sneakbar.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/loading_dialogs.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/standard_appbar.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/helper/helper.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/checkout_country.dart';
import 'widgets/delivery_mode.dart';
import 'widgets/height.dart';
import 'widgets/length.dart';
import 'widgets/weight.dart';
import 'widgets/width.dart';

class PriceEstimationPage extends StatefulWidget {
  const PriceEstimationPage({Key? key}) : super(key: key);

  @override
  PriceEstimationPageState createState() => PriceEstimationPageState();
}

class PriceEstimationPageState extends State<PriceEstimationPage> {
  PriceEstimationBloc priceEstimationBloc = PriceEstimationBloc();
  IndexingBloc countryIndexBloc = IndexingBloc();
  WarehouseAddressBloc warehouseAddressBloc = WarehouseAddressBloc();
  IndexingBloc modeIndexBloc = IndexingBloc();
  IndexingBloc heightCounterBloc = IndexingBloc()..add(Taped(index: 10));
  IndexingBloc widthCounterBloc = IndexingBloc()..add(Taped(index: 10));
  IndexingBloc lengthCounterBloc = IndexingBloc()..add(Taped(index: 10));
  IndexingBloc weightCounterBloc = IndexingBloc()..add(Taped(index: 10));

  ///inherit data
  static TextEditingController countryCtl = TextEditingController();
  static TextEditingController modeCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    countryIndexBloc.close();
    modeIndexBloc.close();
    print(heightCounterBloc.state.toString());
    heightCounterBloc.close();
    widthCounterBloc.close();
    lengthCounterBloc.close();
    weightCounterBloc.close();
    priceEstimationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: priceEstimationBloc,
      listener: (c, state) {
        if (state is FetchingPrice) {
          loadingDialogs(context);
        }
        if (state is ErrorFetchingPrice) {
          Navigator.pop(context);
          errorSnackBar(text: state.error, context: context);
        }
        if (state is FetchedPrice) {
          Navigator.pop(context);
          customDialog(
              context,
              null,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  IntrinsicHeight(
                    child: Row(children: [
                      IntrinsicWidth(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Final Price",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                              maxLines: null,
                            ),
                            Text(state.result.price,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              //                   <--- left side
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Country : ${Helper.capitalize(state.result.country)}",
                              // style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Delivery Mode : ${Helper.capitalize(state.result.mode)}",
                              // style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Height : ${state.result.height} 'cm'",
                              // style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Width : ${state.result.width} 'cm'",
                              // style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Length : ${state.result.length}'cm'",
                              // style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "weight : ${state.result.weight}'kg'",
                              // style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ))
                    ]),
                  ),
                  SizedBox(height: 20),
                  Text("Condition : ${state.result.condition}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text("${state.result.actualWeight}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("${state.result.dimensionalWeight}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text("${state.result.priceCondition}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              () {});
        }
      },
      child: Scaffold(
        appBar: standardAppBar(context, "Price Estimation"),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // MultiBlocProvider(
                    //   providers: [
                    //     BlocProvider(
                    //   create: (BuildContext context) => countryIndexBloc),
                    //   BlocProvider(
                    //   create: (BuildContext context) => warehouseAddressBloc),
                    //   ],
                    //   child: Container(
                    //       margin: EdgeInsets.symmetric(horizontal: 20),
                    //       child: Country()),
                    //   ),
                    BlocProvider(
                      create: (BuildContext context) => countryIndexBloc,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Country(
                            transport_id: '',
                          )),
                    ),
                    SizedBox(height: 15),
                    BlocProvider(
                      create: (BuildContext context) => modeIndexBloc,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: DeliveryMode()),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 15),
                    BlocProvider(
                      create: (BuildContext context) => weightCounterBloc,
                      child: Weight(),
                    ),
                    SizedBox(height: 15),
                    BlocProvider(
                      create: (BuildContext context) => heightCounterBloc,
                      child: Height(),
                    ),
                    SizedBox(height: 15),
                    BlocProvider(
                      create: (BuildContext context) => widthCounterBloc,
                      child: Width(),
                    ),
                    SizedBox(height: 15),
                    BlocProvider(
                      create: (BuildContext context) => lengthCounterBloc,
                      child: Length(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 20),
              child: TextButton(
                  onPressed: () {
                    priceEstimationBloc.add(FetchPrice(
                        estimation: Estimation(
                      country: countryCtl.text,
                      mode: modeCtl.text,
                      height: Height.heightCtl.text,
                      width: Width.heightCtl.text,
                      length: Length.heightCtl.text,
                      weight: Weight.heightCtl.text,
                    )));
                  },
                  style: TextButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.all(15)),
                  child: Text(
                    "Calculate",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
