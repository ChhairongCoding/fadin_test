import 'package:bloc/bloc.dart';
import 'invoking_state.dart';

enum InvokingEvent { invoke, sleep }

class InvokingBloc extends Bloc<InvokingEvent, InvokingState> {
  bool isInvoked = false;
  InvokingBloc() : super(Sleeping());

  @override
  Stream<InvokingState> mapEventToState(InvokingEvent event) async* {
    switch (event) {
      case InvokingEvent.invoke:
        yield Invoked();
        isInvoked = true;
        break;
      case InvokingEvent.sleep:
        yield Sleeping();
        break;
    }
  }
}
