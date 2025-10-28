import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(const AuthState());

  Future<void> appStarted() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final token = await repository.getToken();
    if (token != null && token.isNotEmpty) {
      emit(state.copyWith(status: AuthStatus.authenticated, token: token));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated, token: null));
    }
  }

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final token = await repository.login(username: username, password: password);
      emit(state.copyWith(status: AuthStatus.authenticated, token: token));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, error: e.toString()));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> logout() async {
    await repository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
