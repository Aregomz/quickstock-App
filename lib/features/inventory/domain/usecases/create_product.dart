import '../entities/product.dart';
import '../repositories/inventory_repository.dart';

class CreateProductUseCase {
  final InventoryRepository repository;

  CreateProductUseCase(this.repository);

  Future<void> call(Product product) {
    return repository.addProduct(product);
  }
}
