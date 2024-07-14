import 'package:cartify/models/product.dart';
import 'package:cartify/providers/database_provider.dart';

class ProductRepository {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createProduct(Product product) async {
    final db = await dbProvider.database;
    var result = await db.insert('Products', product.toSqlMap());
    return result;
  }

  Future<int> createProducts(List<Product> products) async {
    final db = await dbProvider.database;
    var batch = db.batch();
    for (var product in products) {
      batch.insert('Products', product.toSqlMap());
    }
    var result = await batch.commit(noResult: true);
    return result.length;
  }

  Future<List<Product>> getAllProducts() async {
    final db = await dbProvider.database;
    var result = await db.query('Products');
    List<Product> products = result.isNotEmpty ? result.map((item) => Product.fromSqlMap(item)).toList() : [];
    return products;
  }

  //get products by seller Id
  Future<List<Product>> getProductsBySellerId(String sellerId) async {
    final db = await dbProvider.database;
    var result = await db.query('Products', where: 'sellerId = ?', whereArgs: [
      sellerId
    ]);
    List<Product> products = result.isNotEmpty ? result.map((item) => Product.fromSqlMap(item)).toList() : [];
    return products;
  }

  Future<Product?> getProductById(String id) async {
    final db = await dbProvider.database;
    var result = await db.query('Products', where: 'id = ?', whereArgs: [
      id
    ]);
    return result.isNotEmpty ? Product.fromSqlMap(result.first) : null;
  }

  Future<int> updateProduct(Product product) async {
    final db = await dbProvider.database;
    return await db.update(
      'Products',
      product.toSqlMap(),
      where: 'id = ?',
      whereArgs: [
        product.id
      ],
    );
  }

  Future<int> deleteProduct(String id) async {
    final db = await dbProvider.database;
    return await db.delete(
      'Products',
      where: 'id = ?',
      whereArgs: [
        id
      ],
    );
  }

  Future<int> deleteAllProducts() async {
    final db = await dbProvider.database;
    return await db.delete('Products');
  }
}
