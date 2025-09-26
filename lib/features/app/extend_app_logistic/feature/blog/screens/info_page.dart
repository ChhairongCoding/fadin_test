import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_category/info_category_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_category/info_category_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_category/info_category_state.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_listing/blog_listing_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_listing/blog_listing_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/repositories/blog_listing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/info_list_by_category.dart';

enum InfoIsBack { isTrue, isFalse }

class InfoPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              InfoCategoryBloc()..add(FetchInfoCategoryStarted()),
        ),
        // BlocProvider(
        //   create: (BuildContext context) =>
        //       InfoListingBloc(infoListingRepository: InfoListRepo())
        //         ..add(InitializeInfoList()),
        // )
      ],
      child: InfoPage(),
    );
  }
}

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoCategoryBloc, InfoCategoryState>(
        builder: (context, state) {
      if (state is ErrorFetchingInfoCategory) {
        return Scaffold(
          body: Center(
            child: TextButton(
                onPressed: () {
                  BlocProvider.of<InfoCategoryBloc>(context)
                      .add(FetchInfoCategoryStarted());
                },
                child: Text("Retry")),
          ),
        );
      } else if (state is FetchedInfoCategory) {
        return DefaultTabController(
          initialIndex: 0,
          length: BlocProvider.of<InfoCategoryBloc>(context)
              .infoCategoryList
              .length,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              centerTitle: true,
              title: Text(
                "Info",
                // AppLocalizations.of(context)!.translate("info")!,
                // style: Theme.of(context).primaryTextTheme.headline6,
              ),
              actions: [],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    // isScrollable: true,
                    //  (_infoCategoryBloc.subCategoryList.length == 0)
                    //     ? false
                    //     : true,
                    dividerColor: Colors.transparent,
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      ...BlocProvider.of<InfoCategoryBloc>(context)
                          .infoCategoryList
                          .map((subCategory) => Tab(text: subCategory.name))
                          .toList()
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                ...BlocProvider.of<InfoCategoryBloc>(context)
                    .infoCategoryList
                    .map(
                      (infoCategory) => BlocProvider(
                          create: (context) => InfoListingBloc(
                              infoListingRepository: InfoListByCategoryRepo())
                            ..add(InitializeInfoList(
                                arg: infoCategory.id.toString())),
                          child: InfoListByCategory(
                            infoCategory: infoCategory,
                          )
                          //_body(subCategory.id.toString()),
                          ),
                    )
                    .toList()
              ],
            ),
          ),
        );
      }
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    });
  }
}
