// import 'package:sqflite/sqflite.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/db_fields.dart';
import 'package:gym_tracker_app/models/plany_treningowe.dart';
import 'package:sqflite/sqflite.dart';

class PlanRepository {
  Future<int> insertPlan(TrainingPlans plan) async {
    final db = await DatabaseServices.instance.database;
    final id = await db.insert(
      DbFields.tablePlan,
      plan.toMap()..remove(DbFields.planId), 
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<TrainingPlans>> getAllPlans() async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(DbFields.tablePlan);
    return result.map((e) => TrainingPlans.fromMap(e)).toList();
  }

  Future<TrainingPlans?> getPlanById(int id) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tablePlan,
      where: '${DbFields.planId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return TrainingPlans.fromMap(result.first);
    return null;
  }
  
  Future<TrainingPlans?> getPlanByName(String name) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tablePlan,
      where: '${DbFields.planName} = ?',
      whereArgs: [name],
    );
    if (result.isNotEmpty) return TrainingPlans.fromMap(result.first);
    return null;
  }

  Future<int> updatePlanName(int planId, String newName) async {
    final db = await DatabaseServices.instance.database;
    return await db.update(
      DbFields.tablePlan,
      {DbFields.planName: newName},
      where: '${DbFields.planId} = ?',
      whereArgs: [planId],
    );
  }

  Future<int> deletePlan(int planId) async {
    final db = await DatabaseServices.instance.database;


    await db.delete(
      DbFields.tablePlanExercise, 
      where: '${DbFields.planExercisePlanId} = ?',

      whereArgs: [planId],
    );

    final affected = await db.delete(
      DbFields.tablePlan, 
      where: 'id_planu = ?',
      whereArgs: [planId],
    );

    return affected;
  }
}
