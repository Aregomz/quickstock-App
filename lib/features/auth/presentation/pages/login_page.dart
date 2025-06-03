import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock_app/core/constants/routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'register_page.dart'; // si no usarás rutas también aquí, déjalo así

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print('LoginPage - Intentando login con email: $email');

    if (email.isNotEmpty && password.isNotEmpty) {
      context.read<AuthCubit>().login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Todos los campos son obligatorios")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            print('LoginPage - Estado actual: $state');
            
            if (state is AuthSuccess) {
              print('LoginPage - Token obtenido después del login: ${state.token}');
              if (state.token.isNotEmpty) {
                print('LoginPage - Navegando al dashboard con token: ${state.token}');
                Navigator.of(context).pushReplacementNamed(
                  Routes.dashboard,
                  arguments: state.token,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Inicio de sesión exitoso")),
                );
              } else {
                print('LoginPage - Token vacío recibido');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Error: Token vacío"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else if (state is AuthFailure) {
              print('LoginPage - Error de autenticación: ${state.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: state is AuthLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () => _login(context),
                          child: const Text('Iniciar sesión'),
                        ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AuthCubit>(),
                          child: const RegisterPage(),
                        ),
                      ),
                    );
                  },
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
