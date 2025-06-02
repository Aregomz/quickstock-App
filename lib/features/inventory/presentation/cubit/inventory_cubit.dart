import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/get_all_products.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/create_product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/update_product.dart';
import 'package:quickstock_app/features/inventory/domain/usecases/delete_product.dart';
import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final GetAllProductsUseCase getAllProducts;
  final CreateProductUseCase createProduct;
  final UpdateProductUseCase updateProduct;
  final DeleteProductUseCase deleteProduct;

  InventoryCubit({
    required this.getAllProducts,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(InventoryInitial());

  Future<void> fetchProducts() async {
    emit(InventoryLoading());
    try {
      final products = await getAllProducts();
      emit(InventoryLoaded(products));
    } catch (e, stacktrace) {
  print('Error en fetchProducts: $e');
  print(stacktrace);
  emit(InventoryError('Error al cargar productos: $e'));
}

  }

  Future<void> addProduct(Product product) async {
    emit(InventoryLoading());
    try {
      await createProduct(product);
      emit(InventorySuccess('Producto agregado'));
      await fetchProducts();
} catch (e, stacktrace) {
  print('Error en addProduct: $e');
  print(stacktrace);
  emit(InventoryError('Error al agregar producto: $e'));
}

  }

  Future<void> editProduct(Product product) async {
    emit(InventoryLoading());
    try {
      await updateProduct(product);
      emit(InventorySuccess('Producto actualizado'));
      await fetchProducts();
    } catch (e) {
      emit(InventoryError('Error al actualizar producto'));
    }
  }

  Future<void> removeProduct(int id) async {
    emit(InventoryLoading());
    try {
      await deleteProduct(id);
      emit(InventorySuccess('Producto eliminado'));
      await fetchProducts();
    } catch (e) {
      emit(InventoryError('Error al eliminar producto'));
    }
  }
}
