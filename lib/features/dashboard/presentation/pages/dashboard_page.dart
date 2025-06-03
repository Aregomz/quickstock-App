import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock_app/core/constants/routes.dart';
import 'package:quickstock_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:quickstock_app/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:quickstock_app/features/dashboard/presentation/widgets/stat_card.dart';

class DashboardPage extends StatefulWidget {
  final String token;
  
  const DashboardPage({
    super.key,
    required this.token,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    print('DashboardPage - Token en initState: ${widget.token}');
    context.read<DashboardCubit>().loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DashboardLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(Routes.login);
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Salir'),
                        ),
                      ],
                    ),
                    const Text(
                      'Resumen de tu inventario',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Total Productos',
                            value: state.totalProducts.toString(),
                            icon: Icons.inventory,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatCard(
                            title: 'Valor Total',
                            value: '\$${state.totalValue.toStringAsFixed(2)}',
                            icon: Icons.attach_money,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Categorías',
                            value: state.totalCategories.toString(),
                            icon: Icons.category,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatCard(
                            title: 'Stock Bajo',
                            value: state.lowStockProducts.toString(),
                            icon: Icons.warning,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Acciones Rápidas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Gestiona tu inventario fácilmente',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                print('DashboardPage - Navegando a Agregar Producto con token: ${widget.token}');
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
                                  Text('Agregar Producto'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  Routes.inventory,
                                  arguments: widget.token,
                                );
                              },
                              icon: const Icon(Icons.visibility),
                              label: const Text('Ver Todos los Productos'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Productos Recientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.recentProducts.length,
                        itemBuilder: (context, index) {
                          final product = state.recentProducts[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(product.name),
                              subtitle: Text(product.category),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${product.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Stock: ${product.stock}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              if (state is DashboardError) {
                return Center(child: Text(state.message));
              }

              return const Center(child: Text('No hay datos disponibles'));
            },
          ),
        ),
      ),
    );
  }
} 