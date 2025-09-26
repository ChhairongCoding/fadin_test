import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class LoginInitialize extends LoginState {}

class Logged extends LoginState {
  final String? token;
  final String? phone;
  const Logged({required this.token, required this.phone});
}

class Logging extends LoginState {}

class ErrorLogin extends LoginState {
  final String message;
  ErrorLogin({required this.message});
}
