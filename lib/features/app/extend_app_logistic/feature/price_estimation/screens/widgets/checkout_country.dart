import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/bloc/price_estimation_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/bloc/price_estimation_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/bloc/price_estimation_state.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/target_country_list.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/screens/price_estimation_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/screens/widgets/delivery_mode.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/bloc/transport_method_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutCountry extends StatefulWidget {
  final String transport_id;
  CheckOutCountry({required this.transport_id});
  @override
  State<CheckOutCountry> createState() => _CheckOutCountryState();
}

class _CheckOutCountryState extends State<CheckOutCountry> {
  final PriceEstimationBloc _blocController = PriceEstimationBloc();
  TextEditingController selectedItem =
      TextEditingController(text: "Select Country");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _blocController.add(FetchTargetCountryById(id: widget.transport_id));
    if (widget.transport_id != '') {
      DeliveryModeState.blocController.add(FetchTransportMethodList(
        id: widget.transport_id,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // List of items for the dropdown
    // final List<String> items = [
    //   'Apple',
    //   'Banana',
    //   'Cherry',
    //   'Date',
    //   'Elderberry'
    // ];
    // Selected item
    // String? selectedItem;
    return BlocBuilder<PriceEstimationBloc, PriceEstimationState>(
        bloc: _blocController,
        builder: (context, state) {
          if (state is FetchingTargetCountryById) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ErrorFetchingTargetCountryById) {
            return Center(child: Text(state.error.toString()));
          }
          if (state is FetchedTargetCountryById) {
            if (selectedItem.text == "Select Country") {
              selectedItem.text = state.targetCountryModel.name.toString();
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.orange[900],
              ),
              child: Text(selectedItem.text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              // DropdownButton<TargetCountryModel>(
              //   // style: TextStyle(color: Colors.black, fontSize: 16),
              //   // value: selectedItem.text,
              //   onTap: () {},
              //   underline: Container(),
              //   padding: EdgeInsets.symmetric(horizontal: 15),
              //   hint: Text(selectedItem.text),
              //   items: state.result.map((TargetCountryModel item) {
              //     return DropdownMenuItem<TargetCountryModel>(
              //       // enabled: false,
              //       value: item,
              //       child: Text(item.name.toString(),
              //           style: TextStyle(
              //             color: Colors.black,
              //           )),
              //     );
              //   }).toList(),
              //   onChanged: (TargetCountryModel? newValue) {
              //     setState(() {
              //       print(newValue!.id.toString() + " " + newValue.name);
              //       selectedItem.text = newValue.name.toString();
              //       DeliveryModeState.countryId.text = newValue.id.toString();
              //       DeliveryModeState.blocController
              //           .add(FetchTransportMethodList(
              //         id: newValue.id.toString(),
              //       ));
              //       PriceEstimationPageState.countryCtl.text =
              //           newValue.name.toString();
              //     });
              //   },
              //   isExpanded: true,
              // ),
            );
          } else {
            return Container(
              child: Text(""),
            );
          }
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _blocController.close();
    selectedItem.clear();
    super.dispose();
  }
}
