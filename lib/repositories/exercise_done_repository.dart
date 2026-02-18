import 'package:gym_tracker_app/models/completed_exercise.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/db_fields.dart';

class ExerciseDoneRepository {
  
  Future<List<CompletedExercise>> getByTrainingId(int treningId) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tableExerciseDone,
      where: '${DbFields.exerciseDoneTrainingId} = ?',
      whereArgs: [treningId],
    );
    return result.map((e) => CompletedExercise.fromMap(e)).toList();
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
