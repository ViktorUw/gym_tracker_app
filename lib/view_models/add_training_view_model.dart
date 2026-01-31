import 'package:flutter/material.dart';
import 'package:gym_tracker_app/models/training_done.dart';
import 'package:gym_tracker_app/repositories/training_done_repository.dart';

class AddTrainingViewModel extends ChangeNotifier {
  final TrainingDoneRepository _repo = TrainingDoneRepository();

  bool isLoading = false;
  String? errorMsg;

  Future<bool> addTraining(TrainingDone training) async {
    isLoading = true;
    errorMsg = null;
    notifyListeners();
      try {
      await _repo.insertTraining(training);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMsg = e.toString();
      notifyListeners();
      return false;
    }
  }
  
}