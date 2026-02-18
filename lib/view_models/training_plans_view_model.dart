import 'package:flutter/material.dart';
import 'package:gym_tracker_app/repositories/plan_repository.dart';
import 'package:gym_tracker_app/models/training_plans.dart';

class TrainingPlansViewModel extends ChangeNotifier {
  final PlanRepository _repo = PlanRepository();

  List<TrainingPlans> _plans = [];
  List<TrainingPlans> get plans => _plans;

  bool isLoading = false;
  String? error;

  Future<void> loadPlans() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _plans = await _repo.getAllPlans();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePlan(int planId) async {
    try {
      final removed = await _repo.deletePlan(planId);
      if (removed > 0) {
        _plans.removeWhere((p) => p.plan_id == planId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      error = e.toString();
      return false;
    }
  }

  Future<bool> updatePlanName(int planId, String newName) async {
    try {
      final updated = await _repo.updatePlanName(planId, newName);
      if (updated > 0) {
        final idx = _plans.indexWhere((p) => p.plan_id == planId);
        if (idx != -1) {
          _plans[idx] = _plans[idx].copyWith(nazwaPlanu: newName);
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      error = e.toString();
      return false;
    }
  }

  Future<TrainingPlans?> createPlan({required String name, String? description}) async {
    try {
      final plan = TrainingPlans(plan_id: null, plan_name: name, planDescription: description);
      final newId = await _repo.insertPlan(plan);
      final created = plan.copyWith(id: newId);
      _plans.add(created);
      notifyListeners();
      return created;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    }
  }
}