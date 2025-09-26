import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/models/search_history.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/repositories/search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  String query = "";
  int searchPageIndex = 0;
  List<Delivery> results = [];
  SearchRepository _searchRepository = SearchRepository();
  List<SearchHistory> historyList = [];
  @override
  SearchBloc() : super(Initializing());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchStarted) {
      try {
        if (event.query != query) {
          query = event.query;
          searchPageIndex = 1;
          yield Searching();
        } else {
          yield Searching(isInitiallySearch: false);
          searchPageIndex++;
        }
        List<Delivery> tempResults = await _searchRepository.searchDelivery(
            page: searchPageIndex, query: event.query);
        results.addAll(tempResults);

        yield Searched();
      } catch (e) {
        yield ErrorSearching(error: e.toString());
      }
    }
    if (event is FetchHistory) {
      try {
        yield Searching(isInitiallySearch: false);

        historyList = await _searchRepository.getHistory(page: 1);

        yield Searched();
      } catch (e) {
        yield ErrorSearching(error: e.toString());
      }
    }
    if (event is ClearHistory) {
      try {
        yield Searching(isInitiallySearch: false);

        await _searchRepository.clearHistory(historyId: event.history.id);
        historyList.remove(event.history);
        yield Searched();
      } catch (e) {
        yield ErrorSearching(error: e.toString());
      }
    }
    if (event is ClearAllHistory) {
      try {
        yield Searching(isInitiallySearch: false);

        await _searchRepository.clearAllHistory();
        historyList.clear();

        yield Searched();
      } catch (e) {
        yield ErrorSearching(error: e.toString());
      }
    }
  }
}
