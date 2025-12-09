import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  final int clientId;
  final String clientName;

  const AddTransactionScreen({
    super.key,
    required this.clientId,
    required this.clientName,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  List<Map<String, dynamic>> _products = [];
  Map<String, dynamic>? _selectedProduct;
  String? _selectedCategory;
  List<String> _categories = [];
  double _totalPrice = 0;
  double _pendingAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _dbHelper.getAllProducts();
    final categories = products.map((p) => p['category'].toString()).toSet().toList();
    
    setState(() {
      _products = products;
      _categories = categories;
      if (categories.isNotEmpty) {
        _selectedCategory = categories[0];
        _filterProductsByCategory();
      }
    });
  }

  void _filterProductsByCategory() {
    if (_selectedCategory != null) {
      _selectedProduct = null;
      _unitPriceController.clear();
      _calculateTotal();
    }
  }

  void _calculateTotal() {
    if (_selectedProduct != null &&
        _quantityController.text.isNotEmpty &&
        _unitPriceController.text.isNotEmpty) {
      
      final quantity = int.tryParse(_quantityController.text) ?? 1;
      final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
      final paidAmount = double.tryParse(_paidAmountController.text) ?? 0;
      
      setState(() {
        _totalPrice = quantity * unitPrice;
        _pendingAmount = _totalPrice - paidAmount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction - ${widget.clientName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selection
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                              _filterProductsByCategory();
                            });
                          },
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Product Selection
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Product',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedProduct,
                      decoration: InputDecoration(
                        labelText: 'Product',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      items: _products
                          .where((product) => product['category'] == _selectedCategory)
                          .map((product) {
                        return DropdownMenuItem(
                          value: product,
                          child: Text('${product['name']} (₹${NumberFormat('#,##0.00').format(product['unit_price'])})'),
                        );
                      }).toList(),
                      onChanged: (product) {
                        setState(() {
                          _selectedProduct = product;
                          _unitPriceController.text = product?['unit_price'].toString() ?? '';
                          _calculateTotal();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Transaction Details
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quantity
                    TextField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateTotal(),
                    ),

                    const SizedBox(height: 16),

                    // Unit Price
                    TextField(
                      controller: _unitPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Price (₹) *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                        prefixText: '₹ ',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateTotal(),
                    ),

                    const SizedBox(height: 16),

                    // Paid Amount
                    TextField(
                      controller: _paidAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Paid Amount (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.payment),
                        prefixText: '₹ ',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateTotal(),
                    ),

                    const SizedBox(height: 16),

                    // Notes
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Calculation Summary
            if (_totalPrice > 0)
              Card(
                elevation: 2,
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calculation Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCalculationRow('Quantity', _quantityController.text),
                      _buildCalculationRow('Unit Price', '₹${NumberFormat('#,##0.00').format(double.tryParse(_unitPriceController.text) ?? 0)}'),
                      const Divider(),
                      _buildCalculationRow('Total Price', '₹${NumberFormat('#,##0.00').format(_totalPrice)}'),
                      _buildCalculationRow('Paid Amount', '₹${NumberFormat('#,##0.00').format(double.tryParse(_paidAmountController.text) ?? 0)}'),
                      _buildCalculationRow('Pending Amount', '₹${NumberFormat('#,##0.00').format(_pendingAmount)}'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _pendingAmount == 0 ? Colors.green[100] : Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _pendingAmount == 0 
                                ? '💰 Fully Paid' 
                                : '📝 ₹${NumberFormat('#,##0.00').format(_pendingAmount)} Pending',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _pendingAmount == 0 ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Transaction',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTransaction() async {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a product'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_quantityController.text.isEmpty || _unitPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter quantity and unit price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
    final paidAmount = double.tryParse(_paidAmountController.text) ?? 0;

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quantity must be greater than 0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (unitPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unit price must be greater than 0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (paidAmount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paid amount cannot be negative'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (paidAmount > _totalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paid amount cannot be more than total price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _dbHelper.addTransaction({
        'client_id': widget.clientId,
        'product_id': _selectedProduct!['id'],
        'quantity': quantity,
        'unit_price': unitPrice,
        'paid_amount': paidAmount,
        'notes': _notesController.text.isNotEmpty ? _notesController.text : null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction saved successfully! Total: ₹${NumberFormat('#,##0.00').format(_totalPrice)}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving transaction: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
