import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock_app/features/inventory/domain/entities/product.dart';
import 'package:quickstock_app/features/inventory/presentation/cubit/inventory_cubit.dart';
import 'package:quickstock_app/features/inventory/presentation/cubit/inventory_state.dart';

class ProductFormModal extends StatefulWidget {
  final Product? product; // null para crear, no null para editar

  const ProductFormModal({super.key, this.product});

  @override
  State<ProductFormModal> createState() => _ProductFormModalState();
}

class _ProductFormModalState extends State<ProductFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _categoryController = TextEditingController(text: p?.category ?? '');
    _priceController = TextEditingController(text: p?.price.toString() ?? '');
    _stockController = TextEditingController(text: p?.stock.toString() ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa $fieldName';
    }
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa $fieldName';
    }
    if (double.tryParse(value) == null) {
      return 'Por favor, ingresa un número válido';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? 0,
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        description: _descriptionController.text.trim(),
      );

      final cubit = context.read<InventoryCubit>();
      if (widget.product == null) {
        cubit.addProduct(product);
      } else {
        cubit.editProduct(product);
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator ?? (value) => _validateField(value, label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing ? 'Editar Producto' : 'Nuevo Producto',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Nombre',
                hint: 'Ingresa el nombre del producto',
              ),
              _buildTextField(
                controller: _categoryController,
                label: 'Categoría',
                hint: 'Ingresa la categoría',
              ),
              _buildTextField(
                controller: _priceController,
                label: 'Precio',
                hint: 'Ingresa el precio',
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'el precio'),
              ),
              _buildTextField(
                controller: _stockController,
                label: 'Stock',
                hint: 'Ingresa la cantidad en stock',
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'el stock'),
              ),
              _buildTextField(
                controller: _descriptionController,
                label: 'Descripción',
                hint: 'Ingresa una descripción del producto',
                maxLines: 3,
              ),
              BlocConsumer<InventoryCubit, InventoryState>(
                listener: (context, state) {
                  if (state is InventorySuccess) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
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
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: state is InventoryLoading ? null : _submit,
                          child: state is InventoryLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(isEditing ? 'Guardar' : 'Crear'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
