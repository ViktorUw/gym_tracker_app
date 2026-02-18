import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/models/weight_measurment.dart';
import 'package:gym_tracker_app/services/db_fields.dart';

class WeightMeasurmentRepository {
  Future<int> insertMassRecord(WeightMeasurment record) async {
    final db = await DatabaseServices.instance.database;
    return await db.insert(DbFields.tableMass, record.toMap());
  }

  Future<List<WeightMeasurment>> getAllForUser(int userId) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tableMass,
      where: '${DbFields.massUserId} = ?',
      whereArgs: [userId],

      orderBy: '${DbFields.massDate} DESC, ${DbFields.massId} DESC',
    );
    return result.map((e) => WeightMeasurment.fromMap(e)).toList();
  }


  Future<int> deleteMassRecord(int id) async {
    final db = await DatabaseServices.instance.database;
    return await db.delete(
      DbFields.tableMass,
      where: '${DbFields.massId} = ?',
      whereArgs: [id],
    );
  }


  Future<bool> updateLatestForUser(int userId, double newWeight) async {
    final db = await DatabaseServices.instance.database;
    final maps = await db.query(
      DbFields.tableMass,
      where: '${DbFields.massUserId} = ?',
      whereArgs: [userId],
      orderBy: '${DbFields.massId} DESC', 
      limit: 1,
    );

    if (maps.isEmpty) return false;
    final latest = maps.first;
    final int? id = latest[DbFields.massId] as int?;
    if (id == null) return false;

    final now = DateTime.now();
    final String formattedDate =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final updated = {
      DbFields.massValue: newWeight,
      DbFields.massDate: formattedDate,
    };

    await db.update(
      DbFields.tableMass,
      updated,
      where: '${DbFields.massId} = ?',
      whereArgs: [id],
    );
    return true;
  }

  Future<WeightMeasurment?> getLatestForUser(int userId) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tableMass,
      where: '${DbFields.massUserId} = ?',
      whereArgs: [userId],
      orderBy: '${DbFields.massId} DESC',
      limit: 1,
    );
    if (result.isNotEmpty) return WeightMeasurment.fromMap(result.first);
    return null;
  }
}
