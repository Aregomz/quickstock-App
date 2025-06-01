import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/constants/api_constants.dart'; // aquí puedes definir baseUrl si lo usas
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  // Crear cliente HTTP
  final client = http.Client();

  // Crear data source
  final authRemoteDataSource = AuthRemoteDataSource(client);

  // Crear repositorio
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);

  // Crear use cases
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);

  // Ejecutar app
  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.registerUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickStock',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => AuthCubit(
          loginUseCase: loginUseCase,
          registerUseCase: registerUseCase,
        ),
        child: const LoginPage(),
      ),
    );
  }
}
