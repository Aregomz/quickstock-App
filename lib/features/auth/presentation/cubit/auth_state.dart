abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  AuthSuccess({required this.token});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}