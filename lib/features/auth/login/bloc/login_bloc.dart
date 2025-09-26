import 'package:fardinexpress/features/auth/login/bloc/login_event.dart';
import 'package:fardinexpress/features/auth/login/bloc/login_state.dart';
import 'package:fardinexpress/features/auth/login/model/login_response.dart';
import 'package:fardinexpress/features/auth/login/repositories/login_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository = LoginRepository();
  LoginBloc() : super(LoginInitialize());
  LoginResponseModel loginResponseModel =
      LoginResponseModel(token: "", phone: "");
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginPressed) {
      yield Logging();
      try {
        loginResponseModel = await _loginRepository.login(
            phone: event.phoneNumber, password: event.password);
        yield Logged(
            token: loginResponseModel.token, phone: loginResponseModel.phone);
      } catch (e) {
        yield ErrorLogin(message: e.toString());
      }
    }
  }
}
