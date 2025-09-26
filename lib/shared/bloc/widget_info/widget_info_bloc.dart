import 'dart:async';
import 'package:bloc/bloc.dart';

import 'widget_info_event.dart';
import 'widget_info_state.dart';

class WidgetInfoBloc extends Bloc<WidgetInfoEvent, WidgetInfoState> {
  @override
  WidgetInfoBloc() : super(FetchingWidgetInfo());

  @override
  Stream<WidgetInfoState> mapEventToState(WidgetInfoEvent event) async* {
    if (event is FetchWidgetInfo) {
      // yield FetchingWidgetInfo();
      yield FetchedWidgetInfo(height: event.height, width: event.width);
    }
  }
}
