import 'package:flutter/material.dart';
import 'package:medmart/services/product.dart';
import 'package:medmart/services/api.dart'; // Import your API service

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _genericNameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.productName);
    _genericNameController = TextEditingController(text: widget.product.genericName);
    _categoryController = TextEditingController(text: widget.product.category);
    _descriptionController = TextEditingController(text: widget.product.productDescription);
    _priceController = TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genericNameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProduct = Product(
        id: widget.product.id,
        productName: _nameController.text,
        genericName: _genericNameController.text,
        category: _categoryController.text,
        productDescription: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        imageUrl: widget.product.imageUrl,
      );

      final success = await ApiService.updateProduct(updatedProduct);
      if (success) {
        Navigator.pop(context);
      } else {

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateProduct,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genericNameController,
                decoration: InputDecoration(labelText: 'Generic Name'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
