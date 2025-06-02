import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/constants/routes.dart';
import 'core/navigation/app_router.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() {
  final client = http.Client();
  final authRemoteDataSource = AuthRemoteDataSource(client);
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);

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
      initialRoute: Routes.login, // 👈 Usamos la constante centralizada
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => AuthCubit(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
          ),
          child: child!,
        );
      },
    );
  }
}
