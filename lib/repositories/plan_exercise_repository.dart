import 'package:gym_tracker_app/models/exercises.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/db_fields.dart';
import 'package:gym_tracker_app/models/plan_exercise.dart';

class PlanExerciseRepository {
  
  Future<int> insertPlanExercise(PlanExercise item) async {
    final db = await DatabaseServices.instance.database;
    return await db.insert(
      DbFields.tablePlanExercise, 
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, 
    );
  }

  Future<int> addExerciseToPlan(int planId, int exerciseId) async {
    final db = await DatabaseServices.instance.database;

    final exists = await db.query(
      DbFields.tablePlanExercise,
      where: 'id_planu = ? AND id_cwiczenia = ?',
      whereArgs: [planId, exerciseId],
      limit: 1,
    );

    if (exists.isNotEmpty) return 0; 
    return await db.insert(
      DbFields.tablePlanExercise,
      {
        'id_planu': planId,
        'id_cwiczenia': exerciseId,
      },
    );
  }

  Future<List<PlanExercise>> getAllPlanExercises() async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(DbFields.tablePlanExercise);
    return result.map((e) => PlanExercise.fromMap(e)).toList();
  }

  Future<int> deletePlanExercise(int planId, int exerciseId) async {
    final db = await DatabaseServices.instance.database;
    return await db.delete(
      DbFields.tablePlanExercise,
      where:
          '${DbFields.planExercisePlanId} = ? AND ${DbFields.planExerciseExerciseID} = ?',
      whereArgs: [planId, exerciseId],
    );
  }
  Future<List<Exercises>> getExercisesForPlan(int planId) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.rawQuery('''
      SELECT e.* FROM ${DbFields.tableExercise} e
      INNER JOIN ${DbFields.tablePlanExercise} pe
      ON e.${DbFields.exerciseId} = pe.${DbFields.planExerciseExerciseID}
      WHERE pe.${DbFields.planExercisePlanId} = ?
    ''', [planId]);

    return result.map((e) => Exercises.fromMap(e)).toList();
  }

  Future<int> deleteExerciseFromPlan(int planId, int exerciseId) async {
    final db = await DatabaseServices.instance.database;
    return await db.delete(
      DbFields.tablePlanExercise,
      where: '${DbFields.planExercisePlanId} = ? AND ${DbFields.planExerciseExerciseID} = ?',
      whereArgs: [planId, exerciseId],
    );
  }
}
