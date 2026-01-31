import 'package:gym_tracker_app/services/db_fields.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/models/exercises.dart';

class ExerciseRepository {
  Future<int> insertExercise(Exercises exercise) async {
    final db = await DatabaseServices.instance.database;
    return await db.insert(DbFields.tableExercise, exercise.toMap());
  }
  
  Future<List<Cwiczenia>> getAllExercises() async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(DbFields.tableExercise);
    return result.map((e) => Cwiczenia.fromMap(e)).toList();
  }

  Future<Cwiczenia?> getExerciseById(int id) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tableExercise,
      where: '${DbFields.exerciseId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Cwiczenia.fromMap(result.first);
    }
    return null;
  }

  Future<Cwiczenia?> getExerciseByName(String name) async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(
      DbFields.tableExercise,
      where: '${DbFields.exerciseName} = ?',
      whereArgs: [name],
    );
    if(result.isNotEmpty){
      return Cwiczenia.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateExercise(Cwiczenia exercise) async {
    final db = await DatabaseServices.instance.database;
    return await db.update(
      DbFields.tableExercise,
      exercise.toMap(),
      where: '${DbFields.exerciseId} = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await DatabaseServices.instance.database;
    return await db.delete(
      DbFields.tableExercise,
      where: '${DbFields.exerciseId} = ?',
      whereArgs: [id],
    );
  }
}
