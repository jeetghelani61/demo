import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'client_management_final.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Clients table
    await db.execute('''
      CREATE TABLE clients(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        address TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT,
        unit_price REAL DEFAULT 0
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER,
        product_id INTEGER,
        quantity INTEGER DEFAULT 1,
        unit_price REAL DEFAULT 0,
        total_price REAL DEFAULT 0,
        paid_amount REAL DEFAULT 0,
        pending_amount REAL DEFAULT 0,
        transaction_date TEXT DEFAULT CURRENT_TIMESTAMP,
        notes TEXT,
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');

    // Insert sample products
    await db.rawInsert('''
      INSERT INTO products (name, category, unit_price) VALUES 
      ('Samsung LED TV 32"', 'TV', 10000),
      ('LG Smart TV 43"', 'TV', 12000),
      ('Whirlpool Double Door Fridge', 'Fridge', 15000),
      ('Godrej Single Door Fridge', 'Fridge', 8000),
      ('Samsung Washing Machine 8kg', 'Washing Machine', 18000),
      ('LG Washing Machine 7kg', 'Washing Machine', 16000),
      ('Voltas AC 1.5 Ton', 'AC', 25000),
      ('Samsung Mobile A50', 'Mobile', 15000),
      ('iPhone 13', 'Mobile', 60000)
    ''');

    // Insert sample clients
    await db.rawInsert('''
      INSERT INTO clients (name, email, phone) VALUES 
      ('Sameer Patel', 'sameer@email.com', '9876543210'),
      ('Mayank Sharma', 'mayank@email.com', '9876543211'),
      ('Rahul Verma', 'rahul@email.com', '9876543212')
    ''');
  }

  // ========== CLIENT OPERATIONS ==========
  Future<int> addClient(String name, String? email, String? phone, String? address) async {
    Database db = await database;
    return await db.insert('clients', {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    });
  }

  Future<List<Map<String, dynamic>>> getAllClients() async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT 
        c.*,
        COALESCE(SUM(t.total_price), 0) as total_amount,
        COALESCE(SUM(t.paid_amount), 0) as total_paid,
        COALESCE(SUM(t.pending_amount), 0) as total_pending,
        COUNT(t.id) as transaction_count
      FROM clients c
      LEFT JOIN transactions t ON c.id = t.client_id
      GROUP BY c.id
      ORDER BY c.name
    ''');
  }

  Future<Map<String, dynamic>> getClientSummary(int clientId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        SUM(total_price) as total_amount,
        SUM(paid_amount) as total_paid,
        SUM(pending_amount) as total_pending,
        COUNT(*) as transaction_count
      FROM transactions 
      WHERE client_id = ?
    ''', [clientId]);
    
    return result.isNotEmpty ? result[0] : {
      'total_amount': 0,
      'total_paid': 0,
      'total_pending': 0,
      'transaction_count': 0
    };
  }

  Future<int> updateClient(int id, String name, String? email, String? phone, String? address) async {
    Database db = await database;
    return await db.update('clients', {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteClient(int id) async {
    Database db = await database;
    return await db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  // ========== PRODUCT OPERATIONS ==========
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    Database db = await database;
    return await db.query('products', orderBy: 'name');
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    Database db = await database;
    return await db.query('products', 
      where: 'category = ?', 
      whereArgs: [category],
      orderBy: 'name'
    );
  }

  // ========== TRANSACTION OPERATIONS ==========
  Future<int> addTransaction(Map<String, dynamic> transaction) async {
    Database db = await database;
    
    // Calculate total price
    double unitPrice = transaction['unit_price'] ?? 0;
    int quantity = transaction['quantity'] ?? 1;
    double totalPrice = unitPrice * quantity;
    double paidAmount = transaction['paid_amount'] ?? 0;
    double pendingAmount = totalPrice - paidAmount;
    
    return await db.insert('transactions', {
      'client_id': transaction['client_id'],
      'product_id': transaction['product_id'],
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'paid_amount': paidAmount,
      'pending_amount': pendingAmount,
      'notes': transaction['notes'],
    });
  }

  Future<List<Map<String, dynamic>>> getClientTransactions(int clientId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT 
        t.*,
        p.name as product_name,
        p.category,
        (t.total_price - t.paid_amount) as remaining_amount
      FROM transactions t
      JOIN products p ON t.product_id = p.id
      WHERE t.client_id = ?
      ORDER BY t.transaction_date DESC
    ''', [clientId]);
  }

  Future<List<Map<String, dynamic>>> getCategoryWiseSummary(int clientId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT 
        p.category,
        COUNT(t.id) as item_count,
        SUM(t.quantity) as total_quantity,
        SUM(t.total_price) as total_amount,
        SUM(t.paid_amount) as total_paid,
        SUM(t.pending_amount) as total_pending
      FROM transactions t
      JOIN products p ON t.product_id = p.id
      WHERE t.client_id = ?
      GROUP BY p.category
      ORDER BY p.category
    ''', [clientId]);
  }

  Future<List<Map<String, dynamic>>> getProductWiseSummary(int clientId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT 
        p.name as product_name,
        p.category,
        SUM(t.quantity) as total_quantity,
        AVG(t.unit_price) as avg_price,
        SUM(t.total_price) as total_amount,
        SUM(t.paid_amount) as total_paid,
        SUM(t.pending_amount) as total_pending
      FROM transactions t
      JOIN products p ON t.product_id = p.id
      WHERE t.client_id = ?
      GROUP BY p.name, p.category
      ORDER BY p.category, p.name
    ''', [clientId]);
  }

  Future<int> addPayment(int transactionId, double amount) async {
    Database db = await database;
    
    // Update transaction
    await db.rawUpdate('''
      UPDATE transactions 
      SET paid_amount = paid_amount + ?, 
          pending_amount = pending_amount - ?
      WHERE id = ?
    ''', [amount, amount, transactionId]);
    
    // Record payment
    return await db.insert('transactions', {
      'client_id': 0, // Will be updated in actual implementation
      'product_id': 0,
      'quantity': 1,
      'unit_price': amount,
      'total_price': amount,
      'paid_amount': amount,
      'pending_amount': 0,
      'notes': 'Payment received',
    });
  }

  Future<List<Map<String, dynamic>>> searchClients(String query) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT 
        c.*,
        COALESCE(SUM(t.total_price), 0) as total_amount,
        COALESCE(SUM(t.paid_amount), 0) as total_paid,
        COALESCE(SUM(t.pending_amount), 0) as total_pending
      FROM clients c
      LEFT JOIN transactions t ON c.id = t.client_id
      WHERE c.name LIKE ?
      GROUP BY c.id
      ORDER BY c.name
    ''', ['%$query%']);
  }
}
