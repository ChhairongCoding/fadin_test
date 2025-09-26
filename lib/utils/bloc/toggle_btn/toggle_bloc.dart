import 'package:flutter_bloc/flutter_bloc.dart';
import 'toggle_event.dart';
import 'toggle_state.dart';

class ToggleBloc extends Bloc<ToggleEvent, ToggleState> {
  ToggleBloc() : super(InitialClick());

  @override
  Stream<ToggleState> mapEventToState(ToggleEvent event) async* {
    if (event is ClickedIndex) {
      yield InitialClick();
      if (event.clicked == true) {
        yield ClickTrue();
      }
      if (event.clicked == false) {
        yield ClickFalse();
      }
    }
  }
}
