import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/bloc/search_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/bloc/search_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/bloc/search_state.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/models/search_history.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/screens/widgets/search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SearchBloc? searchBloc;

class SearchPage extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext? context) {
    assert(context != null);
    final ThemeData? theme = Theme.of(context!);
    assert(theme != null);
    return theme!.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.black),
      // primaryColorBrightness: Brightness.dark,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      // IconButton(
      //   icon: Icon(Icons.close),
      //   onPressed: () {
      //     query = "";
      //   },
      // )
    ];

    // throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          searchBloc!.close();
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_outlined));
    // throw UnimplementedError();
  }

  String? seletedResult;
  @override
  Widget buildResults(BuildContext context) {
    // return Container(width: 10, height: 100, color: Colors.green);
    return SearchResult(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchBloc = SearchBloc()..add(FetchHistory());
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: BlocBuilder(
          bloc: searchBloc,
          builder: (c, state) {
            if (searchBloc!.historyList.length == 0) {
              if (state is Searched) {
                return Container();
              }
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: [
                    ...searchBloc!.historyList
                        .map((history) => Column(
                              children: [_tile(context, history), Divider()],
                            ))
                        .toList(),
                    Container(
                      width: double.infinity,
                      // height: double.infinity,
                      child: TextButton(
                          onPressed: () {
                            searchBloc!.add(ClearAllHistory());
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            "Clear All History",
                            // AppLocalizations.of(context)!
                            //     .translate("clearAllHistory")!,
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                  ]),
                ),
              );
            }
          }),
    );
  }

  _tile(
    BuildContext context,
    SearchHistory history,
  ) {
    return GestureDetector(
      onTap: () {
        query = history.text;
        showResults(context);
      },
      child: Row(
        children: [
          Icon(
            Icons.history,
            color: Colors.grey,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(history.text,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: () {
              searchBloc!.add(ClearHistory(history: history));
            },
            icon: Icon(
              Icons.clear,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
