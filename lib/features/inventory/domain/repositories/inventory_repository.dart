import '../entities/product.dart';

abstract class InventoryRepository {
  Future<List<Product>> getProducts();            
  Future<void> addProduct(Product product);       
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(int id);          
}
