import 'package:gym_tracker_app/services/db_fields.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/models/exercises.dart';

class ExerciseRepository {
  Future<int> insertExercise(Exercises exercise) async {
    final db = await DatabaseServices.instance.database;
    return await db.insert(DbFields.tableExercise, exercise.toMap());
  }
  
  Future<List<Exercises>> getAllExercises() async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(DbFields.tableExercise);
    return result.map((e) => Exercises.fromMap(e)).toList();
  }

  Future<Exercises?> getExerciseById(int id) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tableExercise,
      where: '${DbFields.exerciseId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Exercises.fromMap(result.first);
    }
    return null;
  }

}
