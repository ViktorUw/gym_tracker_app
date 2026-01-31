import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gym_tracker_app/services/db_fields.dart';

class DatabaseServices {

  static Database? _db;
  static final DatabaseServices instance = DatabaseServices._constructor();
  DatabaseServices._constructor();

  Future<Database> get database async{
    if(_db != null) return _db!;
    _db = await getDatabase();
    return _db!;

  }

  Future<Database> getDatabase() async {
    final DatabaseDirPath = await getDatabasesPath();
    final databasePath = join(DatabaseDirPath, "gym_tracker_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        // Uzytkownik
        await db.execute('''
          CREATE TABLE ${DbFields.tableUser} (
          ${DbFields.userId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DbFields.userName} TEXT,
          ${DbFields.userSurname} TEXT,
          ${DbFields.userAge} INTEGER,
          ${DbFields.userHeight} REAL
        );
        ''');

        // Cwiczenia
        await db.execute('''
          CREATE TABLE ${DbFields.tableExercise} (
          ${DbFields.exerciseId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DbFields.exerciseName} TEXT,
          ${DbFields.exerciseDesc} TEXT,
          ${DbFields.exerciseMuscleGroup} TEXT,
          ${DbFields.exerciseGif} TEXT
        );
        ''');

        // Plany treningowe
        await db.execute('''
          CREATE TABLE ${DbFields.tablePlan} (
          ${DbFields.planId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DbFields.planName} TEXT,
          ${DbFields.planDesc} TEXT
        );
        ''');

        // Treningi Wykonane
        await db.execute('''
          CREATE TABLE ${DbFields.tableTraining} (
            ${DbFields.trainingId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DbFields.trainingUserId} INTEGER,
            ${DbFields.trainingDate} TEXT,
            ${DbFields.trainingPlanId} INTEGER,
            ${DbFields.trainingDuration} REAL,
            ${DbFields.trainingVolume} REAL,
            FOREIGN KEY (${DbFields.trainingUserId}) REFERENCES ${DbFields.tableUser}(${DbFields.userId}),
            FOREIGN KEY (${DbFields.trainingPlanId}) REFERENCES ${DbFields.tablePlan}(${DbFields.planId})
        );
        ''');

        // Pomiar Masy
        await db.execute('''
          CREATE TABLE ${DbFields.tableMass}(
            ${DbFields.massId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DbFields.massUserId} INTEGER,
            ${DbFields.massDate} TEXT,
            ${DbFields.massValue} REAL,
            FOREIGN KEY (${DbFields.massUserId}) REFERENCES ${DbFields.tableUser}(${DbFields.userId})
          );
        ''');
        
        // Plan_Cwiczenie
        await db.execute('''
          CREATE TABLE ${DbFields.tablePlanExercise}(
            ${DbFields.planExercisePlanId} INTEGER,
            ${DbFields.planExerciseExerciseID} INTEGER,
            FOREIGN KEY (${DbFields.planExercisePlanId}) REFERENCES ${DbFields.tablePlan}(${DbFields.planId}),
            FOREIGN KEY (${DbFields.planExerciseExerciseID}) REFERENCES ${DbFields.tableExercise}(${DbFields.exerciseId})
          );
        ''');

        // Cwiczenia Wykonane
        await db.execute('''
          CREATE TABLE ${DbFields.tableExerciseDone}(
            ${DbFields.exerciseDoneId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DbFields.exerciseDoneTrainingId} INTEGER,
            ${DbFields.exerciseDoneExerciseId} INTEGER,
            ${DbFields.exerciseDoneWeight} REAL,
            ${DbFields.exerciseDoneReps} INTEGER,
            ${DbFields.exerciseDone1RM} REAL,
            FOREIGN KEY(${DbFields.exerciseDoneExerciseId}) REFERENCES ${DbFields.tableExercise}(${DbFields.exerciseId}),
            FOREIGN KEY(${DbFields.exerciseDoneTrainingId}) REFERENCES ${DbFields.tableTraining}(${DbFields.trainingId})
          )
        ''');

      },
    );
    return database;
  }

  
}
