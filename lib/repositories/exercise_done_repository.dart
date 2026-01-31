import 'package:gym_tracker_app/models/exercise_done.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/db_fields.dart';

class ExerciseDoneRepository {

  Future<int> insertCompletedExercise(ExerciseDone item) async {
    final db = await DatabaseServices.instance.database;
    return await db.insert(DbFields.tableExerciseDone, item.toMap());
  }

  Future<List<ExerciseDone>> getAllCompletedExercises() async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(DbFields.tableExerciseDone);
    return result.map((e) => ExerciseDone.fromMap(e)).toList();
  }

  Future<int> updateCompletedExercise(ExerciseDone item) async {
    final db = await DatabaseServices.instance.database;
    return await db.update(
      DbFields.tableExerciseDone,
      item.toMap(),
      where: '${DbFields.exerciseDoneId} = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteCompletedExercise(int id) async {
    final db = await DatabaseServices.instance.database;
    return await db.delete(
      DbFields.tableExerciseDone,
      where: '${DbFields.exerciseDoneId} = ?',
      whereArgs: [id],
    );
  }

  Future<List<ExerciseDone>> getByTrainingId(int treningId) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tableExerciseDone,
      where: '${DbFields.exerciseDoneTrainingId} = ?',
      whereArgs: [treningId],
    );
    return result.map((e) => ExerciseDone.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getSetsForTraining(int trainingId) async {
    final db = await DatabaseServices.instance.database;
    return db.rawQuery(
      '''
    SELECT cw.${DbFields.exerciseName} AS exercise_name, cww.${DbFields.exerciseDoneWeight} AS weight, cww.${DbFields.exerciseDoneReps} AS reps, cww.${DbFields.exerciseDone1RM} AS one_rm
    FROM ${DbFields.tableExerciseDone} cww
    JOIN ${DbFields.tableExercise} cw ON cw.${DbFields.exerciseId} = cww.${DbFields.exerciseDoneExerciseId}
    WHERE cww.${DbFields.exerciseDoneTrainingId} = ?
    ORDER BY cw.${DbFields.exerciseName}, cww.${DbFields.exerciseDoneId}
    ''',
      [trainingId],
    );
  }
  
}
