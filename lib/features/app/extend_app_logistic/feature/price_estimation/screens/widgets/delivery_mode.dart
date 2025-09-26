import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/screens/price_estimation_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/bloc/transport_method_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/bloc/transport_method_state.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryMode extends StatefulWidget {
  @override
  State<DeliveryMode> createState() => DeliveryModeState();
}

class DeliveryModeState extends State<DeliveryMode> {
  static TransportMethodBloc blocController = TransportMethodBloc();
  TextEditingController selectedItem =
      TextEditingController(text: "Select Delivery Mode");
  static TextEditingController countryId = TextEditingController();
  static TextEditingController tempTranModeId = TextEditingController();
  static TextEditingController tranModeId = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(countryId.text.isEmpty){

    // }else{
    //   _blocController.add(FetchTransportMethodList(id: countryId.text));
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // blocController.close();
    blocController.transportMethods.clear();
    tranModeId.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: blocController,
        builder: (context, state) {
          if (state is FetchingTransportMethod) {
            return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 4 / 2,
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          padding: EdgeInsets.symmetric(horizontal: 15)),
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.white),
                        // style: TextStyle(
                        //     color: (state == 0)
                        //         ? Colors.white
                        //         : Colors.grey[700]),
                      ));
                });
          }
          if (state is ErrorFetchingTransportMethod) {
            return Center(child: Text(state.error.toString()));
          }
          if (state is FetchedTransportMethod) {
            if (blocController.transportMethods.isNotEmpty) {
              PriceEstimationPageState.modeCtl.text =
                  blocController.transportMethods[0].name;
              tempTranModeId.text = blocController.transportMethods[0].name;
            }
            return BlocBuilder<IndexingBloc, int>(builder: (c, stateIndex) {
              return ListView.builder(
                  shrinkWrap: true,
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     childAspectRatio: 4 / 2,
                  //     crossAxisCount: 4,
                  //     crossAxisSpacing: 10,
                  //     mainAxisSpacing: 10),
                  itemCount: blocController.transportMethods.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: (stateIndex == index)
                                ? Colors.green
                                : Colors.white,
                            width: 3),
                        // color:
                        //     (stateIndex == index) ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                          onTap: () {
                            BlocProvider.of<IndexingBloc>(context)
                                .add(Taped(index: index));
                            tranModeId.text =
                                blocController.transportMethods[index].name;
                            PriceEstimationPageState.modeCtl.text =
                                blocController.transportMethods[index].name;
                          },
                          title: Text(
                            blocController.transportMethods[index].name
                                .toString()
                                .toUpperCase(),
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: blocController
                                      .transportMethods[index].description
                                      .toString() ==
                                  "null"
                              ? Text("")
                              : Text(
                                  "estimated time " +
                                      blocController
                                          .transportMethods[index].description,
                                  style: TextStyle(color: Colors.grey[700]),
                                )),
                    );
                    // TextButton(
                    //     onPressed: () {
                    //       BlocProvider.of<IndexingBloc>(context)
                    //           .add(Taped(index: index));
                    //       PriceEstimationPageState.modeCtl.text =
                    //           blocController.transportMethods[index].name;
                    //     },
                    //     style: TextButton.styleFrom(
                    //         elevation: 0,
                    //         backgroundColor: (stateIndex == index)
                    //             ? Theme.of(context).primaryColor.withOpacity(1)
                    //             : Colors.grey[200],
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(18)),
                    //         padding: EdgeInsets.symmetric(horizontal: 15)),
                    //     child: Text(
                    //       blocController.transportMethods[index].name
                    //           .toString(),
                    //       style: TextStyle(
                    //           color: stateIndex == index
                    //               ? Colors.white
                    //               : Theme.of(context).primaryColor),
                    //       // style: TextStyle(
                    //       //     color: (state == 0)
                    //       //         ? Colors.white
                    //       //         : Colors.grey[700]),
                    //     ));
                  });
            });
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 4,
            //       child: Text(
            //         "Select Delivery Mode",
            //         style: TextStyle(color: Colors.black),
            //         textScaleFactor: 1.1,
            //       ),
            //     ),
            //     Expanded(
            //         flex: 6,
            //         child: )
            //   ],
            // );
          } else {
            return Container();
          }
        });
  }
}
