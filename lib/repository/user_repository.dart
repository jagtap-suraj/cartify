import 'package:cartify/models/user.dart';
import 'package:cartify/providers/database_provider.dart';

class UserRepository {
  final dbProvider = DatabaseProvider.dbProvider;

  // Insert a new user into the database
  Future<int> createUser(User user) async {
    final db = await dbProvider.database;
    var result = await db.insert('Users', user.toMap());
    return result;
  }

  // Fetch all users from the database
  Future<List<User>> getAllUsers() async {
    final db = await dbProvider.database;
    var result = await db.query('Users');
    List<User> users = result.isNotEmpty ? result.map((item) => User.fromSqlMap(item)).toList() : [];
    return users;
  }

  // Fetch a single user by id
  Future<User?> getUserById(String id) async {
    final db = await dbProvider.database;
    var result = await db.query('Users', where: 'id = ?', whereArgs: [
      id
    ]);
    return result.isNotEmpty ? User.fromSqlMap(result.first) : null;
  }

  // Update a user in the database
  Future<int> updateUser(User user) async {
    final db = await dbProvider.database;
    return await db.update(
      'Users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [
        user.id
      ],
    );
  }

  // Delete a user from the database
  Future<int> deleteUser(String id) async {
    final db = await dbProvider.database;
    return await db.delete(
      'Users',
      where: 'id = ?',
      whereArgs: [
        id
      ],
    );
  }

  // Delete all users from the database
  Future<int> deleteAllUsers() async {
    final db = await dbProvider.database;
    return await db.delete('Users');
  }
}
