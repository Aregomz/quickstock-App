import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/get_all_products.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetAllProductsUseCase getAllProducts;

  DashboardCubit({
    required this.getAllProducts,
  }) : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    try {
      final products = await getAllProducts();
      
      final totalValue = products.fold(
        0.0,
        (sum, product) => sum + (product.price * product.stock),
      );
      
      final categories = products.map((p) => p.category).toSet().length;
      final lowStockProducts = products.where((p) => p.stock < 10).length;
      final recentProducts = products.take(3).toList();

      emit(DashboardLoaded(
        recentProducts: recentProducts,
        totalProducts: products.length,
        totalValue: totalValue,
        totalCategories: categories,
        lowStockProducts: lowStockProducts,
      ));
    } catch (e) {
      emit(DashboardError('Error al cargar datos del dashboard: $e'));
    }
  }
} 