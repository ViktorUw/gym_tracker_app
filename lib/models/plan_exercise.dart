import 'package:gym_tracker_app/services/db_fields.dart';

class PlanExercise {
  final int? planId;
  final int? cwiczenieId;

  PlanExercise({this.planId, this.cwiczenieId});

  factory PlanExercise.fromMap(Map<String, dynamic> map) => PlanExercise(
    planId: map[DbFields.planExercisePlanId],
    cwiczenieId: map[DbFields.planExerciseExerciseID],
  );

  Map<String, dynamic> toMap() => {
    DbFields.planExercisePlanId: planId,
    DbFields.planExerciseExerciseID: cwiczenieId,
  };
}
