import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final String? token;
  @override
  List<Object> get props => [];
  const AuthState({this.token});
}

class AuthenticationInitialize extends AuthState {}

class Authenticated extends AuthState {
  final String? accessToken;
  const Authenticated({required this.accessToken});
}

class Authenticating extends AuthState {}

class NotAuthenticated extends AuthState {}

class ErrorAuthentication extends AuthState {
  const ErrorAuthentication({required this.error});
  final String error;
}
