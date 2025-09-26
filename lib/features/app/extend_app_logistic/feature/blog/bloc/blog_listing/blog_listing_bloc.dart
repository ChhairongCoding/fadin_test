import 'package:bloc/bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/models/info.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/repositories/blog_listing_repository.dart';

import 'blog_listing_event.dart';
import 'blog_listing_state.dart';

class InfoListingBloc extends Bloc<InfoListingEvent, InfoListingState> {
  InfoListingBloc({required this.infoListingRepository, this.rowPerPage = 10})
      : super(InitializingInfoList());

  final InfoListingRepository infoListingRepository;
  int page = 1;
  List<Info> infoList = [];
  final int rowPerPage;
  @override
  Stream<InfoListingState> mapEventToState(InfoListingEvent event) async* {
    if (event is InitializeInfoList) {
      yield InitializingInfoList();
      try {
        page = 1;
        infoList = await infoListingRepository.getInfoList(
            page: page, rowPerPage: rowPerPage, additionalArg: event.arg);
        page++;
        print(infoList.length);
        yield InitializedInfoList();
      } catch (e) {
        print(e);
        yield ErrorInitializingInfoList(error: e.toString());
      }
    }
    if (event is FetchInfoList) {
      yield FetchingInfoList();
      try {
        List<Info> _tempInfoList = await infoListingRepository.getInfoList(
            page: page, rowPerPage: rowPerPage, additionalArg: event.arg);
        infoList.addAll(_tempInfoList);
        page++;
        if (_tempInfoList.length < rowPerPage) {
          yield EndOfInfoList();
        } else {
          yield FetchedInfoList();
        }
      } catch (e) {
        yield ErrorInitializingInfoList(error: e.toString());
      }
    }
  }
}
