import 'package:flutter_bloc/flutter_bloc.dart';

import 'navbar_indexing_event.dart';

class NavbarIndexingBloc extends Bloc<NavbarIndexingEvent, int> {
  @override
  NavbarIndexingBloc() : super(1);

  @override
  Stream<int> mapEventToState(NavbarIndexingEvent event) async* {
    if (event is Taped) {
      yield event.index;
    }
  }
}

// IndexingBloc categoryIndexBloc = IndexingBloc();

NavbarIndexingBloc selectingBloc = NavbarIndexingBloc();
