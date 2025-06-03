import 'package:quickstock_app/features/inventory/domain/entities/product.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Product> recentProducts;
  final int totalProducts;
  final double totalValue;
  final int totalCategories;
  final int lowStockProducts;

  DashboardLoaded({
    required this.recentProducts,
    required this.totalProducts,
    required this.totalValue,
    required this.totalCategories,
    required this.lowStockProducts,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
} 