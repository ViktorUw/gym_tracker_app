import 'package:gym_tracker_app/services/db_fields.dart';

class ExerciseDone {
  final int? id;
  final int? treningId;
  final int? cwiczenieId;
  final double? waga;
  final int? iloscPowtorzen;
  final double? oneRM;

  ExerciseDone({
    this.id,
    this.treningId,
    this.cwiczenieId,
    this.waga,
    this.iloscPowtorzen,
    this.oneRM,
  });

  factory ExerciseDone.fromMap(Map<String, dynamic> map) =>
      ExerciseDone(
        id: map[DbFields.exerciseDoneId],
        treningId: map[DbFields.exerciseDoneTrainingId],
        cwiczenieId: map[DbFields.exerciseDoneExerciseId],
        waga:
            map[DbFields.exerciseDoneWeight] is int
                ? (map[DbFields.exerciseDoneWeight] as int).toDouble()
                : map[DbFields.exerciseDoneWeight],
        iloscPowtorzen: map[DbFields.exerciseDoneReps],
        oneRM:
            map[DbFields.exerciseDone1RM] is int
                ? (map[DbFields.exerciseDone1RM] as int).toDouble()
                : map[DbFields.exerciseDone1RM],
      );

  Map<String, dynamic> toMap() => {
    DbFields.exerciseDoneId: id,
    DbFields.exerciseDoneTrainingId: treningId,
    DbFields.exerciseDoneExerciseId: cwiczenieId,
    DbFields.exerciseDoneWeight: waga,
    DbFields.exerciseDoneReps: iloscPowtorzen,
    DbFields.exerciseDone1RM: oneRM,
  };
}
