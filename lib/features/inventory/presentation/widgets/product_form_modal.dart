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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      print('ProductFormModal: Iniciando edición/creación de producto');
      final newProduct = Product(
        id: widget.product?.id ?? 0,
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        stock: int.tryParse(_stockController.text.trim()) ?? 0,
        description: _descriptionController.text.trim(),
      );

      print('ProductFormModal: Producto a enviar: ${newProduct.id}, ${newProduct.name}, ${newProduct.category}');
      final cubit = context.read<InventoryCubit>();

      if (widget.product == null) {
        print('ProductFormModal: Creando nuevo producto');
        cubit.addProduct(newProduct);
      } else {
        print('ProductFormModal: Editando producto existente');
        cubit.editProduct(newProduct);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    print('ProductFormModal: Construyendo formulario. isEditing: $isEditing');

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
      child: BlocConsumer<InventoryCubit, InventoryState>(
        listener: (context, state) {
          print('ProductFormModal: Estado recibido: $state');
          if (state is InventorySuccess) {
            print('ProductFormModal: Operación exitosa');
            Navigator.of(context).pop(); // cerrar el modal
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is InventoryError) {
            print('ProductFormModal: Error recibido: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditing ? 'Editar Producto' : 'Nuevo Producto',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(_nameController, 'Nombre', true),
                      _buildTextField(_categoryController, 'Categoría', true),
                      _buildTextField(_priceController, 'Precio', true, inputType: TextInputType.number),
                      _buildTextField(_stockController, 'Stock', true, inputType: TextInputType.number),
                      _buildTextField(_descriptionController, 'Descripción', false),
                      const SizedBox(height: 20),
                      if (state is InventoryLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _submit,
                          child: Text(isEditing ? 'Guardar cambios' : 'Crear producto'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool required, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: required
            ? (value) => (value == null || value.trim().isEmpty) ? 'Este campo es obligatorio' : null
            : null,
      ),
    );
  }
}
