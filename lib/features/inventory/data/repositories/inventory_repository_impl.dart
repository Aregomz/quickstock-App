import 'package:quickstock_app/features/inventory/domain/entities/product.dart';
import 'package:quickstock_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:quickstock_app/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:quickstock_app/features/inventory/data/models/product_model.dart';  // Importa ProductModel aquí

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;
  final String token;

  InventoryRepositoryImpl(this.remoteDataSource, this.token);

@override
Future<List<Product>> getProducts() async {
  final productModels = await remoteDataSource.getAllProducts(token);
  return productModels.map((model) => model.toEntity()).toList();
}


@override
Future<void> addProduct(Product product) {
  final productModel = ProductModel.fromEntity(product);
  return remoteDataSource.createProduct(productModel, token);
}


@override
Future<void> updateProduct(Product product) {
  final productModel = ProductModel.fromEntity(product);
  return remoteDataSource.updateProduct(productModel, token);
}

  @override
  Future<void> deleteProduct(int id) {
    print('InventoryRepositoryImpl - Eliminando producto con ID: $id');
    print('InventoryRepositoryImpl - Token: $token');
    return remoteDataSource.deleteProduct(id, token);
  }
}
