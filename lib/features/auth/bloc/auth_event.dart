import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthEvent {}

class UserLoggedIn extends AuthEvent {
  final String? token;
  UserLoggedIn({required this.token});
}

class UserLoggedOut extends AuthEvent {}
