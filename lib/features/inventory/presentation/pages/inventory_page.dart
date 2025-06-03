import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock_app/core/constants/routes.dart';
import 'package:quickstock_app/features/inventory/domain/entities/product.dart';
import 'package:quickstock_app/features/inventory/presentation/cubit/inventory_cubit.dart';
import 'package:quickstock_app/features/inventory/presentation/cubit/inventory_state.dart';

class InventoryPage extends StatefulWidget {
  final String token;

  const InventoryPage({
    super.key,
    required this.token,
  });

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  String _selectedCategory = 'Todos';
  final _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  Set<String> _categories = {'Todos'};
  int _totalProducts = 0;

  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().getAllProducts();
  }

  List<Product> _getFilteredProducts(List<Product> products) {
    final searchTerm = _searchController.text.toLowerCase();
    return products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(searchTerm) ||
          product.category.toLowerCase().contains(searchTerm);
      final matchesCategory =
          _selectedCategory == 'Todos' || product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Set<String> _getCategories(List<Product> products) {
    return {'Todos', ...products.map((p) => p.category).toSet()};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<InventoryCubit, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.read<InventoryCubit>().getAllProducts();
            } else if (state is InventoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is InventoryLoaded) {
              _filteredProducts = _getFilteredProducts(state.products);
              _categories = _getCategories(state.products);
              _totalProducts = state.products.length;
            }

            return Column(
              children: [
                // Barra superior
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Text(
                        'Productos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' • $_totalProducts productos',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar productos...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (state is InventoryLoaded) {
                          _filteredProducts = _getFilteredProducts(state.products);
                        }
                      });
                    },
                  ),
                ),

                // Filtros de categoría
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(category),
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                              if (state is InventoryLoaded) {
                                _filteredProducts = _getFilteredProducts(state.products);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Botón Agregar Nuevo Producto
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        Routes.addProduct,
                        arguments: widget.token,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Agregar Nuevo Producto'),
                      ],
                    ),
                  ),
                ),

                // Lista de productos
                Expanded(
                  child: state is InventoryLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is InventoryLoaded
                          ? ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = _filteredProducts[index];
                                final isLowStock = product.stock < 10;

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.name,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    product.category,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    // TODO: Implementar edición
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete),
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: const Text('Eliminar producto'),
                                                        content: const Text(
                                                            '¿Estás seguro de que deseas eliminar este producto?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(context).pop(),
                                                            child: const Text('Cancelar'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                              context
                                                                  .read<InventoryCubit>()
                                                                  .deleteProduct(product.id);
                                                            },
                                                            child: const Text(
                                                              'Eliminar',
                                                              style: TextStyle(color: Colors.red),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${product.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                            if (isLowStock)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red[100],
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  'Stock bajo: ${product.stock}',
                                                  style: TextStyle(
                                                    color: Colors.red[900],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                            else
                                              Text(
                                                'Stock: ${product.stock}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No hay productos disponibles'),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
