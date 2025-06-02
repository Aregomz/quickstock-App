// data/models/product_model.dart
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required int id,
    required String name,
    required String category,
    required double price,
    required int stock,
    required String description,
  }) : super(
          id: id,
          name: name,
          category: category,
          price: price,
          stock: stock,
          description: description,
        );

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      stock: product.stock,
      description: product.description,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      category: category,
      price: price,
      stock: stock,
      description: description,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'] is String
          ? double.parse(json['price'])
          : (json['price'] as num).toDouble(),
      stock: json['stock'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'description': description,
    };
  }
}

