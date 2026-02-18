import 'package:gym_tracker_app/services/db_fields.dart';

class CompletedTraining {
  final int? id;
  final int? userId;
  final String? date;
  final int? planId;
  final double? duration;
  final double? volume;

  CompletedTraining({
    this.id,
    this.userId,
    this.date,
    this.planId,
    this.duration,
    this.volume,
  });

  factory CompletedTraining.fromMap(Map<String, dynamic> map) => CompletedTraining(
    id: map[DbFields.trainingId],
    userId: map[DbFields.trainingUserId],
    date: map[DbFields.trainingDate],
    planId: map[DbFields.trainingPlanId],
    duration:
        map[DbFields.trainingDuration] is int
            ? (map[DbFields.trainingDuration] as int).toDouble()
            : map[DbFields.trainingDuration],
    volume:
        map[DbFields.trainingVolume] is int
            ? (map[DbFields.trainingVolume] as int).toDouble()
            : map[DbFields.trainingVolume],
  );

  Map<String, dynamic> toMap() => {
    DbFields.trainingId: id,
    DbFields.trainingUserId: userId,
    DbFields.trainingDate: date,
    DbFields.trainingPlanId: planId,
    DbFields.trainingDuration: duration,
    DbFields.trainingVolume: volume,
  };
}
