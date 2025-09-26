import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/screens/widgets/delivery_item_tile.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/bloc/search_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/bloc/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../search_page.dart';

class SearchResult extends StatefulWidget {
  SearchResult({required this.query});
  final String query;
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    searchBloc!.add(SearchStarted(query: widget.query));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: searchBloc,
      listener: (context, dynamic state) {
        if (state is Searched) {
          _refreshController.loadComplete();
        } else if (state is ErrorSearching) {
          _refreshController.loadFailed();
        }
      },
      child: SmartRefresher(
        onLoading: () {
          searchBloc!.add(SearchStarted(query: widget.query));
        },
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          completeDuration: Duration(milliseconds: 500),
        ),
        enablePullDown: false,
        enablePullUp: true,
        controller: _refreshController,
        child: BlocBuilder(
            bloc: searchBloc,
            builder: (BuildContext context, dynamic state) {
              if (state is Searching && state.isInitiallySearch) {
                return Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              }
              if (searchBloc!.results.length == 0) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(
                        AssetImage("assets/extend_assets/icons/empty-box.png"),
                        size: 120,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Empty",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.grey[500]),
                      )
                    ]);
              }
              return SingleChildScrollView(
                child: ListView.builder(
                  itemCount: searchBloc!.results.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return DeliveryItemTile(
                        arrivedLocal: false,
                        delivery: searchBloc!.results[index]);
                  },
                ),
              );
              // return Column(
              //   children: [
              //     GridView.builder(
              //       physics: NeverScrollableScrollPhysics(),
              //       shrinkWrap: true,
              //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           childAspectRatio: 4 / 5.7,
              //           crossAxisCount: 2,
              //           crossAxisSpacing: 2,
              //           mainAxisSpacing: 2),
              //       itemCount: searchBloc!.results.length,
              //       itemBuilder: (context, index) {
              //         return Text("j");
              //         // return GestureDetector(
              //         //     onTap: () {},
              //         //     child: ProductTile(
              //         //         product: searchBloc!.results[index]));
              //       },
              //     ),
              //     (state is Searching && state.isInitiallySearch == false)
              //         ? GridView.builder(
              //             physics: NeverScrollableScrollPhysics(),
              //             shrinkWrap: true,
              //             padding:
              //                 EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              //             gridDelegate:
              //                 SliverGridDelegateWithFixedCrossAxisCount(
              //                     childAspectRatio: 4 / 5.7,
              //                     crossAxisCount: 2,
              //                     crossAxisSpacing: 7,
              //                     mainAxisSpacing: 7),
              //             itemCount: 6,
              //             itemBuilder: (context, index) {
              //               return Text("hh");
              //             },
              //           )
              //         : Container()
              //   ],
              // );
            }),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchBloc!.results.clear();
    super.dispose();
  }
}
