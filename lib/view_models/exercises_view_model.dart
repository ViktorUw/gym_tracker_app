import 'package:flutter/material.dart';
import 'package:gym_tracker_app/models/exercises.dart';
import 'package:gym_tracker_app/repositories/exercise_repository.dart';
import 'package:gym_tracker_app/repositories/plan_exercise_repository.dart';

class ExercisesViewModel extends ChangeNotifier {
  final ExerciseRepository _exRepo = ExerciseRepository();
  final PlanExerciseRepository _exPlanRepo = PlanExerciseRepository();
  final PlanExerciseRepository _planExerciseRepo = PlanExerciseRepository();
  bool isLoading = false;
  String? error;
  List<Exercises> get cwiczeniaWPlanie => _cwiczeniaWPlanie;
  List<Exercises> _cwiczeniaWPlanie = [];
  List<Exercises> get allExercises => cwiczenia;


  List<Exercises> cwiczenia = [];
  String _searchQuery = '';
  String? _selectedGroup;
  String get searchQuery => _searchQuery;
  String? get selectedGroup => _selectedGroup;
  List<String> get availableGroups {
    final groups = cwiczenia.map((exrc) => exrc.muscleGroup).whereType<String>().toSet().toList();
    groups.sort();
    return groups;
  }
  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }
  void setSelectedGroup(String? group) {
    _selectedGroup = group;
    notifyListeners();
  }
  List<Exercises> get filteredExercises {
    return cwiczenia.where((exrc) {
      final matchesGroup = _selectedGroup == null || _selectedGroup == 'Wszystkie' || exrc.muscleGroup == _selectedGroup;
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          (exrc.exerciseName?.toLowerCase().contains(q) ?? false) ||
          (exrc.exerciseDescription?.toLowerCase().contains(q) ?? false);
      return matchesGroup && matchesQuery;
    }).toList();
  }


  Future<void> loadExercises() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      cwiczenia = await _exRepo.getAllExercises();
    } catch (e) {
      error = e.toString();
    } finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadExercisesForPlan(int planId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _cwiczeniaWPlanie = await _exPlanRepo.getExercisesForPlan(planId);
    } catch (e) {
      error = e.toString();
    } finally{
      isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> addExerciseToPlan(int planId, int exerciseId) async {
    try {
      final insertedId = await _planExerciseRepo.addExerciseToPlan(planId, exerciseId);
      return insertedId > 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeExerciseFromPlan(int planId, int exerciseId) async {
    final index = _cwiczeniaWPlanie.indexWhere((e) => e.exerciseID == exerciseId);
    var removedItem;
    if (index != -1) {
      removedItem = _cwiczeniaWPlanie.removeAt(index);
      notifyListeners();
    }
    try {
      final affected = await _planExerciseRepo.deleteExerciseFromPlan(planId, exerciseId);
      if (affected > 0) {
        return true;
      } else {
        if (removedItem != null) {
          _cwiczeniaWPlanie.insert(index, removedItem);
          notifyListeners();
        }
        return false;
      }
    } catch (e) {
      if (removedItem != null) {
        _cwiczeniaWPlanie.insert(index, removedItem);
        notifyListeners();
      }
      return false;
    }
  }
}