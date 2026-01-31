import 'package:gym_tracker_app/models/training_done.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/db_fields.dart';
import 'package:gym_tracker_app/models/exercise_done.dart';
import 'package:gym_tracker_app/views/training_summary_view.dart';

class TrainingDoneRepository {
  Future<int> insertTraining(TrainingDone training) async {
    final db = await DatabaseServices.instance.database;
    return await db.insert(DbFields.tableTraining, training.toMap());
  }

  Future<List<TrainingDone>> getAllTrainings() async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(DbFields.tableTraining);
    return result.map((e) => TrainingDone.fromMap(e)).toList();
  }

  Future<TrainingDone?> getTrainingById(int id) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tableTraining,
      where: '${DbFields.trainingId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return TrainingDone.fromMap(result.first);
    return null;
  }

  Future<int> updateTraining(TrainingDone training) async {
    final db = await DatabaseServices.instance.database;
    return await db.update(
      DbFields.tableTraining,
      training.toMap(),
      where: '${DbFields.trainingId} = ?',
      whereArgs: [training.id],
    );
  }

  Future<int> deleteTraining(int id) async {
    final db = await DatabaseServices.instance.database;
    return await db.delete(
      DbFields.tableTraining,
      where: '${DbFields.trainingId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertTrainingWithExercises(
    TrainingDone training,
    List<ExerciseDone> exercises,
  ) async {
    final db = await DatabaseServices.instance.database;
    return await db.transaction<int>((txn) async {
      final newTrainingId = await txn.insert(
        DbFields.tableTraining,
        training.toMap(),
      );
      for (final ex in exercises) {
        final map = Map<String, dynamic>.from(ex.toMap());
        map[DbFields.exerciseDoneTrainingId] = newTrainingId;
        await txn.insert(DbFields.tableExerciseDone, map);
      }
      return newTrainingId;
    });
  }

  Future<TrainingDone?> getLastTrainingForPlan({
    required int userId,
    required int planId,
  }) async {
    final db = await DatabaseServices.instance.database;

    final res = await db.query(
      DbFields.tableTraining,
      where:
          '${DbFields.trainingUserId} = ? AND ${DbFields.trainingPlanId} = ?',
      whereArgs: [userId, planId],
      orderBy: '${DbFields.trainingId} DESC',
      limit: 1,
    );

    if (res.isEmpty) return null;
    return TrainingDone.fromMap(res.first);
  }

  Future<TrainingSummaryView?> getTrainingSummaryById(int trainingId) async {
    final db = await DatabaseServices.instance.database;

    final result = await db.rawQuery(
      '''
      SELECT
        p.${DbFields.planName} AS training_name,
        t.${DbFields.trainingDate} AS training_date,
        t.${DbFields.trainingVolume} AS volume,
        t.${DbFields.trainingDuration} AS duration
      FROM ${DbFields.tableTraining} t
      LEFT JOIN ${DbFields.tablePlan} p
        ON p.${DbFields.planId} = t.${DbFields.trainingPlanId}
      WHERE t.${DbFields.trainingId} = ?
      ''',
      [trainingId],
    );

    if (result.isEmpty) return null;

    final row = result.first;

    return TrainingSummaryView(
      trainingName: row['training_name'] as String? ?? 'Trening',
      trainingDate: row['training_date'] as String? ?? '',
      totalVolume: (row['volume'] as num?)?.toDouble() ?? 0.0,
      duration: (row['duration'] as num?)?.toString() ?? '0',
    );
  }
}
