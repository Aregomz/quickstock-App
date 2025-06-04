import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/get_all_products.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/create_product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/update_product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/delete_product.dart';
import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final CreateProductUseCase createProduct;
  final UpdateProductUseCase updateProduct;
  final DeleteProductUseCase deleteProductUseCase;

  InventoryCubit({
    required this.getAllProductsUseCase,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProductUseCase,
  }) : super(InventoryInitial());

  Future<void> getAllProducts() async {
    print('InventoryCubit - Obteniendo todos los productos');
    emit(InventoryLoading());
    try {
      final products = await getAllProductsUseCase();
      print('InventoryCubit - Productos obtenidos: ${products.length}');
      emit(InventoryLoaded(products));
    } catch (e) {
      print('InventoryCubit - Error al obtener productos: $e');
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await createProduct(product);
      emit(InventorySuccess('Producto agregado'));
      await getAllProducts();
    } catch (e) {
      print('InventoryCubit - Error al agregar producto: $e');
      emit(InventoryError('Error al agregar producto: $e'));
    }
  }

  Future<void> editProduct(Product product) async {
    try {
      await updateProduct(product);
      emit(InventorySuccess('Producto actualizado'));
      await getAllProducts();
    } catch (e) {
      print('InventoryCubit - Error al editar producto: $e');
      emit(InventoryError('Error al editar producto: $e'));
    }
  }

  Future<void> deleteProduct(int id) async {
    print('InventoryCubit - Iniciando eliminación de producto con ID: $id');
    emit(InventoryLoading());
    try {
      await deleteProductUseCase(id);
      print('InventoryCubit - Producto eliminado exitosamente');
      emit(InventorySuccess('Producto eliminado exitosamente'));
      await getAllProducts();
    } catch (e) {
      print('InventoryCubit - Error al eliminar producto: $e');
      emit(InventoryError('Error al eliminar producto: $e'));
    }
  }
}
