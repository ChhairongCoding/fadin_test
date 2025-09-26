import 'package:fardinexpress/shared/bloc/item_indexing.dart/item_indexing_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemIndexingBloc extends Bloc<ItemIndexingEvent, int> {
  ItemIndexingBloc() : super(0);

  @override
  Stream<int> mapEventToState(ItemIndexingEvent event) async* {
    if (event is Taped) {
      yield event.index;
    }
  }
}
