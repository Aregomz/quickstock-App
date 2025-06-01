import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(email, password);
      emit(AuthSuccess(token: user.token));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> register(String email, String password) async {
  try {
    emit(AuthLoading());
    await registerUseCase(email, password);
    emit(AuthInitial()); 
  } catch (e) {
    emit(AuthError(e.toString()));
    }
  }
}



