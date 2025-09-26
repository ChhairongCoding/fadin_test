import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/models/info_category.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/repositories/blog_category_repository.dart';

import 'info_category_event.dart';
import 'info_category_state.dart';

class InfoCategoryBloc extends Bloc<InfoCategoryEvent, InfoCategoryState> {
  List<InfoCategory> infoCategoryList = [];
  InfoCategoryRepository _infoCategoryRepository = InfoCategoryRepository();
  @override
  InfoCategoryBloc() : super(FetchingInfoCategory());

  @override
  Stream<InfoCategoryState> mapEventToState(InfoCategoryEvent event) async* {
    if (event is FetchInfoCategoryStarted) {
      yield FetchingInfoCategory();
      try {
        await Future.delayed(Duration(milliseconds: 1000));
        List<InfoCategory> temp = [];
        temp = await _infoCategoryRepository.getInfoCategory();
        infoCategoryList.addAll(temp);
        yield FetchedInfoCategory();
      } catch (e) {
        yield ErrorFetchingInfoCategory(error: e.toString());
      }
    }
  }
}
