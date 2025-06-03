import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:quickstock_app/core/constants/routes.dart';
import 'package:quickstock_app/features/auth/presentation/pages/login_page.dart';
import 'package:quickstock_app/features/auth/presentation/pages/register_page.dart';
import 'package:quickstock_app/features/inventory/presentation/pages/inventory_page.dart';
import 'package:quickstock_app/features/inventory/presentation/pages/add_product_page.dart';
import 'package:quickstock_app/features/dashboard/presentation/pages/dashboard_page.dart';

import 'package:quickstock_app/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:quickstock_app/features/inventory/data/repositories/inventory_repository_impl.dart';

import 'package:quickstock_app/features/inventory/domain/usecases/get_all_products.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/create_product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/update_product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/delete_product.dart';

import 'package:quickstock_app/features/inventory/presentation/cubit/inventory_cubit.dart';
import 'package:quickstock_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case Routes.dashboard:
      case Routes.inventory:
      case Routes.addProduct:
        final token = settings.arguments as String?;
        print('AppRouter - Ruta: ${settings.name}, Token recibido: $token');
        
        if (token == null || token.isEmpty) {
          print('AppRouter - Token inválido o no proporcionado');
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
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

        final inventoryCubit = InventoryCubit(
          getAllProductsUseCase: getAllProductsUseCase,
          createProduct: createProductUseCase,
          updateProduct: updateProductUseCase,
          deleteProductUseCase: deleteProductUseCase,
        );

        final dashboardCubit = DashboardCubit(
          getAllProducts: getAllProductsUseCase,
        );

        if (settings.name == Routes.dashboard) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: inventoryCubit),
                BlocProvider.value(value: dashboardCubit),
              ],
              child: DashboardPage(token: token),
            ),
          );
        }

        if (settings.name == Routes.addProduct) {
          print('AppRouter - Creando ruta AddProduct con token: $token');
          return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: inventoryCubit,
              child: const AddProductPage(),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: inventoryCubit,
            child: InventoryPage(token: token),
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
