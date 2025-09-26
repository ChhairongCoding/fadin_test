import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_category/info_category_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_listing/blog_listing_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_listing/blog_listing_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/bloc/blog_listing/blog_listing_state.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/models/info_category.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/repositories/blog_listing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'info_list.dart';

class InfoListByCategoryWrapper extends StatefulWidget {
  final InfoCategory infoCategory;
  InfoListByCategoryWrapper({required this.infoCategory});

  @override
  _InfoListByCategoryWrapperState createState() =>
      _InfoListByCategoryWrapperState();
}

class _InfoListByCategoryWrapperState extends State<InfoListByCategoryWrapper> {
  final InfoCategoryBloc infoDetailBloc = InfoCategoryBloc();
  @override
  void dispose() {
    infoDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          InfoListingBloc(infoListingRepository: InfoListByCategoryRepo())
            ..add(InitializeInfoList(arg: widget.infoCategory.id.toString())),
      child: InfoListByCategory(
        infoCategory: widget.infoCategory,
      ),
    );
  }
}

class InfoListByCategory extends StatefulWidget {
  final InfoCategory infoCategory;
  InfoListByCategory({required this.infoCategory});
  @override
  _InfoListByCategoryState createState() => _InfoListByCategoryState();
}

class _InfoListByCategoryState extends State<InfoListByCategory>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    BlocProvider.of<InfoListingBloc>(context)
        .add(InitializeInfoList(arg: widget.infoCategory.id));
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<InfoListingBloc, InfoListingState>(
      builder: (context, state) {
        if (state is InitializingInfoList) {
          return Center(child: CircularProgressIndicator());
        }

        return BlocListener<InfoListingBloc, InfoListingState>(
          listener: (context, state) async {
            if (state is FetchedInfoList) {
              _refreshController.loadComplete();
              _refreshController.refreshCompleted();
            }
            if (state is EndOfInfoList) {
              _refreshController.loadNoData();
            }
          },
          child: SmartRefresher(
            scrollDirection: Axis.vertical,
            onRefresh: () {
              BlocProvider.of<InfoListingBloc>(context)
                  .add(InitializeInfoList(arg: widget.infoCategory.id));
            },
            onLoading: () {
              if (BlocProvider.of<InfoListingBloc>(context).state
                  is EndOfInfoList) {
              } else {
                BlocProvider.of<InfoListingBloc>(context)
                    .add(FetchInfoList(arg: widget.infoCategory.id));
              }
            },
            enablePullDown: true,
            enablePullUp: true,
            controller: _refreshController,
            child: InfoList(
                // isHorizontal: true,
                ),
          ),
        );
      },
    );
  }
}
