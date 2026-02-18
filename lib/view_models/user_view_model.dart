import 'package:flutter/material.dart';
import 'package:gym_tracker_app/models/weight_measurment.dart';
import 'package:gym_tracker_app/models/user.dart';
import 'package:gym_tracker_app/repositories/weight_measurment_repository.dart';
import 'package:gym_tracker_app/repositories/user_repository.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/db_fields.dart';
import 'package:gym_tracker_app/models/completed_trainings.dart';
import 'package:gym_tracker_app/repositories/training_done_repository.dart';
import 'package:gym_tracker_app/models/completed_exercise.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final treningRepo = TrainingDoneRepository();
  final WeightMeasurmentRepository _pomiarMasyRepository = WeightMeasurmentRepository();

  User? _user;
  User? get user => _user;

  double? latestWeight;
  List<WeightMeasurment> weightRecords = [];

  Future<bool> hasUser() async {
    final users = await _userRepository.getAllUser();
    if (users.isNotEmpty) {
      _user = users.first;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> addUser(User newUser) async {
    await _userRepository.insertUser(newUser);
    notifyListeners();
  }

  Future<void> loadUser() async {
    final db = await DatabaseServices.instance.database;
    final result = await db.query(DbFields.tableUser);
    if (result.isNotEmpty) {
      _user = User.fromMap(result.first);
      notifyListeners();
    }
    if (_user != null) {
      await loadLatestWeight();
      await loadWeightRecords(); 
    }
  }

  Future<void> deleteUser(int id) async {
    final db = await DatabaseServices.instance.database;
    await db.delete(DbFields.tableUser);
    _user = null;
    notifyListeners();
  }

  Future<void> updateUser(User updateUser) async {
    await _userRepository.updateUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> loadLatestWeight() async {
    if (_user == null) return;
    final pomiar = await _pomiarMasyRepository.getLatestForUser(_user!.id!);
    latestWeight = pomiar?.value;
    notifyListeners();
  }

  Future<void> loadWeightRecords() async {
    if (_user == null) return;
    weightRecords = await _pomiarMasyRepository.getAllForUser(_user!.id!);
    if (weightRecords.isNotEmpty) {
      latestWeight = weightRecords.first.value;
    }
    notifyListeners();
  }

  Future<bool> changeLatestWeight(double newWeight) async {
    if (_user == null) return false;
    final success = await _pomiarMasyRepository.updateLatestForUser(_user!.id!, newWeight);
    if (!success) return false;
    latestWeight = newWeight;
    await loadWeightRecords(); 
    return true;
  }

  Future<bool> addWeightRecord(double weight) async {
    if (_user == null) return false;

    try {
      final now = DateTime.now();
      final String formattedDate =
          "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final record = WeightMeasurment(
        userId: _user!.id!,
        date: formattedDate,
        value: weight,
      );

      await _pomiarMasyRepository.insertMassRecord(record);
      await loadWeightRecords();
      return true;
    } catch (e) {
      debugPrint('Error inserting weight record: $e');
      return false;
    }
  }

  Future<bool> deleteWeightRecord(int recordId) async {
    if (_user == null) return false;

    try {
      await _pomiarMasyRepository.deleteMassRecord(recordId);
      await loadWeightRecords(); 
      return true;
    } catch (e) {
      debugPrint('Error deleting weight record: $e');
      return false;
    }
  }

  Future<bool> saveTreningWykonany({
    required int planId,
    required String trainingName,
    required double startWeight,
    required int durationSeconds,
    required double totalVolume,
    required List<CompletedExercise> completedExercises,
  }) async {
    if (_user == null) return false;


    final trening = CompletedTraining(
      id: null,
      userId: _user!.id,
      date: DateTime.now().toIso8601String(),
      planId: planId,
      duration: durationSeconds.toDouble(),
      volume: totalVolume,
    );

    try {
      await treningRepo.insertTrainingWithExercises(
        trening,
        completedExercises,
      );

      if (latestWeight == null ||
          (latestWeight! - startWeight).abs() > 0.0001) {
        await addWeightRecord(startWeight); 
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving training: $e');
      return false;
    }
  }
}
