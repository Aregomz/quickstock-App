import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock_app/features/inventory/domain/entities/product.dart';
import 'package:quickstock_app/features/inventory/presentation/cubit/inventory_cubit.dart';
import 'package:quickstock_app/features/inventory/presentation/cubit/inventory_state.dart';
import 'package:quickstock_app/features/inventory/presentation/widgets/product_form_modal.dart';
import 'package:quickstock_app/features/inventory/presentation/widgets/product_card.dart';


class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<InventoryCubit>().fetchProducts(),
          ),
        ],
      ),
      body: BlocBuilder<InventoryCubit, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No hay productos.'));
            }
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductCard(product: product);
              },
            );
          } else if (state is InventoryError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (BuildContext modalContext) {
              return BlocProvider.value(
                value: context.read<InventoryCubit>(),
                child: ProductFormModal(product: null),
              );
            },
          );
                },  
        child: const Icon(Icons.add),
      ),
    );
  }
}
