import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'add_transaction_screen.dart';

class ClientDetailScreen extends StatefulWidget {
  final int clientId;
  final String clientName;

  const ClientDetailScreen({
    super.key,
    required this.clientId,
    required this.clientName,
  });

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _categorySummary = [];
  List<Map<String, dynamic>> _productSummary = [];
  Map<String, dynamic> _clientSummary = {};
  Map<String, dynamic> _clientDetails = {};
  int _selectedTab = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    final transactions = await _dbHelper.getClientTransactions(widget.clientId);
    final categorySummary = await _dbHelper.getCategoryWiseSummary(widget.clientId);
    final productSummary = await _dbHelper.getProductWiseSummary(widget.clientId);
    final clientSummary = await _dbHelper.getClientSummary(widget.clientId);
    
    setState(() {
      _transactions = transactions;
      _categorySummary = categorySummary;
      _productSummary = productSummary;
      _clientSummary = clientSummary;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.clientName),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            tabs: const [
              Tab(text: 'Summary', icon: Icon(Icons.dashboard)),
              Tab(text: 'Transactions', icon: Icon(Icons.list)),
              Tab(text: 'Category Wise', icon: Icon(Icons.category)),
              Tab(text: 'Product Wise', icon: Icon(Icons.shopping_cart)),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildSummaryTab(),
                  _buildTransactionsTab(),
                  _buildCategoryWiseTab(),
                  _buildProductWiseTab(),
                ],
              ),
        floatingActionButton: _selectedTab == 1
            ? FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTransactionScreen(
                        clientId: widget.clientId,
                        clientName: widget.clientName,
                      ),
                    ),
                  );
                  _loadData();
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  Widget _buildSummaryTab() {
    final totalAmount = _clientSummary['total_amount'] ?? 0;
    final totalPaid = _clientSummary['total_paid'] ?? 0;
    final totalPending = _clientSummary['total_pending'] ?? 0;
    final transactionCount = _clientSummary['transaction_count'] ?? 0;
    final paidPercentage = totalAmount > 0 ? (totalPaid / totalAmount) * 100 : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Financial Summary Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    '💰 Financial Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSummaryRow('Total Transactions', transactionCount.toString()),
                  _buildSummaryRow('Grand Total', '₹${_formatNumber(totalAmount)}'),
                  _buildSummaryRow('Total Paid', '₹${_formatNumber(totalPaid)}'),
                  _buildSummaryRow('Total Pending', '₹${_formatNumber(totalPending)}'),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: paidPercentage / 100,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                    minHeight: 10,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${paidPercentage.toStringAsFixed(1)}% Paid',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Category Summary Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Category Wise Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (_categorySummary.isEmpty)
                    const Center(
                      child: Text(
                        'No category data available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ..._categorySummary.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                category['category'],
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Chip(
                              label: Text('${category['total_quantity']} items'),
                              backgroundColor: Colors.grey[100],
                            ),
                            const SizedBox(width: 10),
                            Chip(
                              label: Text('₹${_formatNumber(category['total_amount'])}'),
                              backgroundColor: Colors.blue[50],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Recent Transactions
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🛒 Recent Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (_transactions.isEmpty)
                    const Center(
                      child: Text(
                        'No transactions yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ..._transactions.take(3).map((transaction) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[50],
                          child: Text(transaction['quantity'].toString()),
                        ),
                        title: Text(
                          transaction['product_name'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(transaction['transaction_date']),
                            )}'),
                            Text('Price: ₹${_formatNumber(transaction['unit_price'])} × ${transaction['quantity']}'),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${_formatNumber(transaction['total_price'])}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Pending: ₹${_formatNumber(transaction['pending_amount'])}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  if (_transactions.length > 3)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedTab = 1;
                          });
                        },
                        child: const Text('View All Transactions'),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    if (_transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              'No Transactions Yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add your first transaction using + button',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        final totalPrice = transaction['total_price'] ?? 0;
        final paidAmount = transaction['paid_amount'] ?? 0;
        final pendingAmount = transaction['pending_amount'] ?? 0;
        final remainingAmount = totalPrice - paidAmount;
        final isFullyPaid = remainingAmount <= 0;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isFullyPaid ? Colors.green[100] : Colors.orange[100],
              child: Icon(
                isFullyPaid ? Icons.check : Icons.pending,
                color: isFullyPaid ? Colors.green : Colors.orange,
              ),
            ),
            title: Text(
              transaction['product_name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${transaction['category']} • ${DateFormat('dd/MM/yyyy').format(
                    DateTime.parse(transaction['transaction_date']),
                  )}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      label: Text('${transaction['quantity']} × ₹${_formatNumber(transaction['unit_price'])}'),
                      backgroundColor: Colors.grey[100],
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text('Total: ₹${_formatNumber(totalPrice)}'),
                      backgroundColor: Colors.blue[50],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      label: Text('Paid: ₹${_formatNumber(paidAmount)}'),
                      backgroundColor: Colors.green[50],
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text('Pending: ₹${_formatNumber(pendingAmount)}'),
                      backgroundColor: Colors.orange[50],
                    ),
                  ],
                ),
                if (transaction['notes'] != null && transaction['notes'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Note: ${transaction['notes']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isFullyPaid ? Colors.green[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isFullyPaid ? Colors.green : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isFullyPaid ? 'PAID' : '₹${_formatNumber(remainingAmount)} DUE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isFullyPaid ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () => _showTransactionDetails(transaction),
          ),
        );
      },
    );
  }

  Widget _buildCategoryWiseTab() {
    if (_categorySummary.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              'No Category Data',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add transactions to see category-wise summary',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _categorySummary.length,
      itemBuilder: (context, index) {
        final category = _categorySummary[index];
        final totalAmount = category['total_amount'] ?? 0;
        final totalPaid = category['total_paid'] ?? 0;
        final totalPending = category['total_pending'] ?? 0;
        final itemCount = category['item_count'] ?? 0;
        final quantity = category['total_quantity'] ?? 0;
        final paidPercentage = totalAmount > 0 ? (totalPaid / totalAmount) * 100 : 0;

        IconData categoryIcon;
        Color iconColor;

        switch (category['category'].toLowerCase()) {
          case 'tv':
            categoryIcon = Icons.tv;
            iconColor = Colors.blue;
            break;
          case 'fridge':
            categoryIcon = Icons.kitchen;
            iconColor = Colors.green;
            break;
          case 'washing machine':
            categoryIcon = Icons.local_laundry_service;
            iconColor = Colors.purple;
            break;
          case 'ac':
            categoryIcon = Icons.ac_unit;
            iconColor = Colors.teal;
            break;
          case 'mobile':
            categoryIcon = Icons.phone_android;
            iconColor = Colors.red;
            break;
          default:
            categoryIcon = Icons.category;
            iconColor = Colors.grey;
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          elevation: 2,
          child: ExpansionTile(
            leading: Icon(categoryIcon, color: iconColor, size: 30),
            title: Text(
              category['category'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text('$quantity items • $itemCount transactions'),
            trailing: Chip(
              label: Text('₹${_formatNumber(totalAmount)}'),
              backgroundColor: Colors.blue[50],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    _buildCategoryDetailRow('Total Items', '$quantity items'),
                    _buildCategoryDetailRow('Transactions', '$itemCount'),
                    _buildCategoryDetailRow('Total Amount', '₹${_formatNumber(totalAmount)}'),
                    _buildCategoryDetailRow('Amount Paid', '₹${_formatNumber(totalPaid)}'),
                    _buildCategoryDetailRow('Amount Pending', '₹${_formatNumber(totalPending)}'),
                    _buildCategoryDetailRow('Payment Status', '${paidPercentage.toStringAsFixed(1)}% Paid'),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: paidPercentage / 100,
                      backgroundColor: Colors.grey[
