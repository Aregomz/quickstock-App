import '../entities/product.dart';
import '../repositories/inventory_repository.dart';

class UpdateProductUseCase {
  final InventoryRepository repository;

  UpdateProductUseCase(this.repository);

  Future<void> call(Product product) {
    return repository.updateProduct(product);
  }
}
