import 'package:equatable/equatable.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.token,
    this.error,
  });

  AuthState copyWith({AuthStatus? status, String? token, String? error}) => AuthState(
        status: status ?? this.status,
        token: token ?? this.token,
        error: error,
      );

  @override
  List<Object?> get props => [status, token, error];
}
