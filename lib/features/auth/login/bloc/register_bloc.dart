import 'package:fardinexpress/features/auth/login/bloc/register_event.dart';
import 'package:fardinexpress/features/auth/login/bloc/register_state.dart';
import 'package:fardinexpress/features/auth/login/model/register_response.dart';
import 'package:fardinexpress/features/auth/login/repositories/register_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterRepository registerRepository = RegisterRepository();
  @override
  RegisterBloc() : super(Initializing());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    UserResponseModel userResponseModel;
    if (event is RegisterPressed) {
      yield Registering();
      try {
        userResponseModel = await registerRepository.register(
            name: event.name,
            phone: event.phoneNumber,
            password: event.password);
        yield Registered(
            token: userResponseModel.token.toString(),
            phone: userResponseModel.phone.toString());
      } catch (e) {
        yield ErrorRegistering(error: e.toString());
      }
    }
  }
}
