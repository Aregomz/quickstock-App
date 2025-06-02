import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:quickstock_app/core/constants/routes.dart';
import 'package:quickstock_app/features/auth/presentation/pages/login_page.dart';
import 'package:quickstock_app/features/auth/presentation/pages/register_page.dart';
import 'package:quickstock_app/features/inventory/presentation/pages/inventory_page.dart';

import 'package:quickstock_app/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:quickstock_app/features/inventory/data/repositories/inventory_repository_impl.dart';

import 'package:quickstock_app/features/inventory/domain/usecases/get_all_products.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/create_product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/update_product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/delete_product.dart';

import 'package:quickstock_app/features/inventory/presentation/cubit/inventory_cubit.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case Routes.inventory:
        final token = settings.arguments as String?;
        if (token == null || token.isEmpty) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('Token inválido o no proporcionado')),
            ),
          );
        }

        final client = http.Client();
        final inventoryRemoteDataSource = InventoryRemoteDataSource(client);
        final inventoryRepository = InventoryRepositoryImpl(inventoryRemoteDataSource, token);

        final getAllProductsUseCase = GetAllProductsUseCase(inventoryRepository);
        final createProductUseCase = CreateProductUseCase(inventoryRepository);
        final updateProductUseCase = UpdateProductUseCase(inventoryRepository);
        final deleteProductUseCase = DeleteProductUseCase(inventoryRepository);

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => InventoryCubit(
              getAllProducts: getAllProductsUseCase,
              createProduct: createProductUseCase,
              updateProduct: updateProductUseCase,
              deleteProduct: deleteProductUseCase,
            ),
            child: const InventoryPage(),
          ),
        );



      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
