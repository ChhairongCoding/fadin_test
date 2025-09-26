import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_listing/blog_listing_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_listing/blog_listing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'info_tile.dart';
import 'info_tile_skeleton.dart';

class InfoList extends StatefulWidget {
  final bool isForVerticalScrolling;
  InfoList({this.isForVerticalScrolling = true});

  @override
  _InfoListState createState() => _InfoListState();
}

class _InfoListState extends State<InfoList> {
  @override
  Widget build(BuildContext context) {
    if (widget.isForVerticalScrolling == false) {
      return BlocBuilder<InfoListingBloc, InfoListingState>(
          builder: (BuildContext context, InfoListingState state) {
        print(state);
        if (BlocProvider.of<InfoListingBloc>(context).infoList.length == 0) {
          return Container(
            width: 0,
            height: 0,
          );
        }
        return Container();
        //  return Text("hh");
        // return Container(
        //   margin: EdgeInsets.only(left: 10, right: 0),
        //   child: ListView.builder(
        //     cacheExtent: 10,
        //     shrinkWrap: true,
        //     // physics: NeverScrollableScrollPhysics(),
        //     scrollDirection: Axis.horizontal,
        //     itemCount:
        //         BlocProvider.of<InfoListingBloc>(context).infoList.length,
        //     itemBuilder: (context, index) {
        //       return AspectRatio(
        //         aspectRatio: 4 / 5.8,
        //         child: Container(
        //             margin: EdgeInsets.only(right: 5), child: Text("Info")
        //             // ProductTile(
        //             //   isVerticalParent: false,
        //             //   //showIcon: true,
        //             //   product: BlocProvider.of<InfoListingBloc>(context)
        //             //       .productList[index],
        //             // ),
        //             ),
        //       );
        //     },
        //   ),
        // );
      });
    }
    print(BlocProvider.of<InfoListingBloc>(context).infoList.length);

    return Container(
      padding: EdgeInsets.all(10),
      child: BlocBuilder<InfoListingBloc, InfoListingState>(
        builder: (context, state) {
          print(BlocProvider.of<InfoListingBloc>(context).infoList.length);
          if (state is InitializingInfoList) {
            return GridView.builder(
              // cacheExtent: 10,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 10 / 3.5,
                  crossAxisCount: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 10),
              itemCount: 6,
              itemBuilder: (context, index) {
                return infoTileSkeleton();
              },
            );
          } else if (state is ErrorFetchingInfoList) {
            return Container();
          }
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:
                  BlocProvider.of<InfoListingBloc>(context).infoList.length,
              itemBuilder: (c, index) {
                print(index);
                return InfoTile(
                    info: BlocProvider.of<InfoListingBloc>(context)
                        .infoList[index]);
              });
          // return Column(
          //   children: [
          //     GridView.builder(
          //       cacheExtent: 0,
          //       physics: NeverScrollableScrollPhysics(),
          //       shrinkWrap: true,
          //       // padding: EdgeInsets.only(left: 10, top: 10, right: 0),
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           childAspectRatio: 4 / 5.7,
          //           crossAxisCount: 2,
          //           crossAxisSpacing: 8,
          //           mainAxisSpacing: 10),
          //       itemCount:
          //           BlocProvider.of<InfoListingBloc>(context).infoList.length,
          //       itemBuilder: (context, index) {
          //         return Text("Info2");
          //         // return ProductTile(
          //         //   // showIcon: true,
          //         //   product: BlocProvider.of<InfoListingBloc>(context)
          //         //       .productList[index],
          //         // );
          //       },
          //     ),
          //     // (state is FetchingInfoList)
          //     // ? GridView.builder(
          //     //     physics: NeverScrollableScrollPhysics(),
          //     //     shrinkWrap: true,
          //     //     padding:
          //     //         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //     //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     //         childAspectRatio: 4 / 5.7,
          //     //         crossAxisCount: 2,
          //     //         crossAxisSpacing: 8,
          //     //         mainAxisSpacing: 10),
          //     //     itemCount: 6,
          //     //     itemBuilder: (context, index) {
          //     //       return productTileSkeleton();
          //     //     },
          //     //   )
          //     // : Container()
          //   ],
          // );
        },
      ),
    );
  }
}
