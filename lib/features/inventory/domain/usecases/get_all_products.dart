import '../entities/product.dart';
import '../repositories/inventory_repository.dart';

class GetAllProductsUseCase {
  final InventoryRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<List<Product>> call() {
    return repository.getProducts();
  }
}
