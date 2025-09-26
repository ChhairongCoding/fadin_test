import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  RegisterState([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class Initializing extends RegisterState {}

class Registered extends RegisterState {
  final String? token;
  final String? phone;
  Registered({required this.token, required this.phone});
}

class Registering extends RegisterState {}

class ErrorRegistering extends RegisterState {
  final String error;
  ErrorRegistering({required this.error});
}
