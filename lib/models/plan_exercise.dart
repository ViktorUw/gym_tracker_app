import 'package:gym_tracker_app/services/db_fields.dart';

class PlanExercise {
  final int? planId;
  final int? exerciseId;

  PlanExercise({this.planId, this.exerciseId});

  factory PlanExercise.fromMap(Map<String, dynamic> map) => PlanExercise(
    planId: map[DbFields.planExercisePlanId],
    exerciseId: map[DbFields.planExerciseExerciseID],
  );

  Map<String, dynamic> toMap() => {
    DbFields.planExercisePlanId: planId,
    DbFields.planExerciseExerciseID: exerciseId,
  };
}
