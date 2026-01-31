import 'package:gym_tracker_app/services/db_fields.dart';

class TrainingDone {
  final int? id;
  final int? userId;
  final String? data;
  final int? planId;
  final double? czasTrwania;
  final double? objetosc;

  TrainingDone({
    this.id,
    this.userId,
    this.data,
    this.planId,
    this.czasTrwania,
    this.objetosc,
  });

  factory TrainingDone.fromMap(Map<String, dynamic> map) => TrainingDone(
    id: map[DbFields.trainingId],
    userId: map[DbFields.trainingUserId],
    data: map[DbFields.trainingDate],
    planId: map[DbFields.trainingPlanId],
    czasTrwania:
        map[DbFields.trainingDuration] is int
            ? (map[DbFields.trainingDuration] as int).toDouble()
            : map[DbFields.trainingDuration],
    objetosc:
        map[DbFields.trainingVolume] is int
            ? (map[DbFields.trainingVolume] as int).toDouble()
            : map[DbFields.trainingVolume],
  );

  Map<String, dynamic> toMap() => {
    DbFields.trainingId: id,
    DbFields.trainingUserId: userId,
    DbFields.trainingDate: data,
    DbFields.trainingPlanId: planId,
    DbFields.trainingDuration: czasTrwania,
    DbFields.trainingVolume: objetosc,
  };
}
