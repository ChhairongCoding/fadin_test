import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/auth/bloc/auth_event.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/auth/repositories/auth_repository.dart';
import 'package:fardinexpress/features/cart/controller/cart_store_controller.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  /// {@macro counter_bloc}
  AuthenticationBloc() : super(AuthenticationInitialize());
  final AuthRepository _authenticationRepository = AuthRepository();
  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }
    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }
    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationInitialize();
    try {
      // await Future.delayed(Duration(milliseconds: 500));
      final _token = await _authenticationRepository.getToken();

      if (_token != null) {
        ApiProvider.accessToken = _token;
        yield Authenticated(
          accessToken: _token,
        );
      } else {
        yield NotAuthenticated();
      }
    } catch (e) {
      yield ErrorAuthentication(error: e.toString());
    }
  }

  Stream<AuthState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    yield Authenticating();
    await _authenticationRepository.saveToken(token: event.token);
    // Get.find<CartStoreController>();
    // Get.put(() => AccountController().getAccountInfo());
    ApiProvider.accessToken = event.token;
    yield Authenticated(accessToken: event.token);
    Get.find<AccountController>().getAccountInfo();
    Get.find<CartStoreController>().getCartStoreList();
  }

  Stream<AuthState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    yield Authenticating();
    // await Future.delayed(Duration(milliseconds: 500), () {});
    await _authenticationRepository.removeToken();
    ApiProvider.accessToken = null;
    yield NotAuthenticated();
  }
}
