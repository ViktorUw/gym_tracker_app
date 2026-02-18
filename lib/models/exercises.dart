import 'package:gym_tracker_app/services/db_fields.dart';

class Exercises {
  final int? exerciseID;
  final String? exerciseName;
  final String? exerciseDescription;
  final String? muscleGroup;
  final String? gifUrl;

  Exercises({this.exerciseID, this.exerciseName, this.exerciseDescription, this.muscleGroup, this.gifUrl});

  factory Exercises.fromMap(Map<String, dynamic> map) => Exercises(
    exerciseID: map[DbFields.exerciseId],
    exerciseName: map[DbFields.exerciseName],
    exerciseDescription: map[DbFields.exerciseDesc],
    muscleGroup: map[DbFields.exerciseMuscleGroup],
    gifUrl: map[DbFields.exerciseGif],
  );

  Map<String, dynamic> toMap() => {
    DbFields.exerciseId : exerciseID,
    DbFields.exerciseName: exerciseName,
    DbFields.exerciseDesc: exerciseDescription,
    DbFields.exerciseMuscleGroup: muscleGroup,
    DbFields.exerciseGif: gifUrl,
  };
}
