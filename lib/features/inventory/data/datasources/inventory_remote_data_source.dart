import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/product_model.dart';

class InventoryRemoteDataSource {
  final http.Client client;

  InventoryRemoteDataSource(this.client);

Future<List<ProductModel>> getAllProducts(String token) async {
  final response = await client.get(
    Uri.parse('$baseUrl/api/productos'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print('Respuesta completa del backend: ${response.body}');

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    final List<dynamic>? productList = decoded['products'];  // <-- Aquí cambió

    if (productList == null) {
      throw Exception('La clave "products" no se encuentra en la respuesta.');
    }

    return productList.map((json) => ProductModel.fromJson(json)).toList();
  } else {
    throw Exception('Error al obtener productos: ${response.statusCode}');
  }
}




  

Future<void> createProduct(ProductModel product, String token) async {
  final response = await client.post(
    Uri.parse('$baseUrl/api/productos'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(product.toJson()),
  );

  if (response.statusCode != 201) {
    print('Error al crear producto: ${response.statusCode} - ${response.body}');
    throw Exception('Error al crear el producto');
  }
}


  Future<void> updateProduct(ProductModel product, String token) async {
    final url = Uri.parse('$baseUrl/api/productos/${product.id}');
    final payload = product.toJson();
    print('UpdateProduct: URL: $url');
    print('UpdateProduct: Token: $token');
    print('UpdateProduct: Payload: $payload');

    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    print('Respuesta de actualización: ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el producto: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteProduct(int id, String token) async {
    print('DeleteProduct: Intentando eliminar producto con ID: $id');
    print('DeleteProduct: Token: $token');
    
    final url = Uri.parse('$baseUrl/api/productos/$id');
    print('DeleteProduct: URL: $url');
    
    final response = await client.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('DeleteProduct: Respuesta del servidor - Status: ${response.statusCode}');
    print('DeleteProduct: Respuesta del servidor - Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el producto: ${response.statusCode} - ${response.body}');
    }
  }
}
