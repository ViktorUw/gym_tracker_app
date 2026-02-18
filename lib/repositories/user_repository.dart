import 'package:gym_tracker_app/models/user.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/db_fields.dart';

class UserRepository {
  Future<int> insertUser(User user) async{
    final db = await DatabaseServices.instance.database;
    return await db.insert(DbFields.tableUser, user.toMap());
  }

  Future<List<User>> getAllUser() async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(DbFields.tableUser);
    return result.map((e) => User.fromMap(e)).toList();

  }

  Future<int> updateUser(User user) async {
    final db = await DatabaseServices.instance.database;
    return await db.update(
      DbFields.tableUser,
      user.toMap(),
      where: '${DbFields.userId} = ?',
      whereArgs: [user.id],
    );
  }

}