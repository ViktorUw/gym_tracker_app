import 'package:gym_tracker_app/services/db_fields.dart';

class CompletedExercise {
  final int? id;
  final int? treningId;
  final int? exerciseId;
  final double? weight;
  final int? reps;
  final double? oneRM;

  CompletedExercise({
    this.id,
    this.treningId,
    this.exerciseId,
    this.weight,
    this.reps,
    this.oneRM,
  });

  factory CompletedExercise.fromMap(Map<String, dynamic> map) =>
      CompletedExercise(
        id: map[DbFields.exerciseDoneId],
        treningId: map[DbFields.exerciseDoneTrainingId],
        exerciseId: map[DbFields.exerciseDoneExerciseId],
        weight:
            map[DbFields.exerciseDoneWeight] is int
                ? (map[DbFields.exerciseDoneWeight] as int).toDouble()
                : map[DbFields.exerciseDoneWeight],
        reps: map[DbFields.exerciseDoneReps],
        oneRM:
            map[DbFields.exerciseDone1RM] is int
                ? (map[DbFields.exerciseDone1RM] as int).toDouble()
                : map[DbFields.exerciseDone1RM],
      );

  Map<String, dynamic> toMap() => {
    DbFields.exerciseDoneId: id,
    DbFields.exerciseDoneTrainingId: treningId,
    DbFields.exerciseDoneExerciseId: exerciseId,
    DbFields.exerciseDoneWeight: weight,
    DbFields.exerciseDoneReps: reps,
    DbFields.exerciseDone1RM: oneRM,
  };
}
