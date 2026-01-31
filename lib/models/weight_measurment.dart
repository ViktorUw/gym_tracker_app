import 'package:gym_tracker_app/services/db_fields.dart';

class WeightMeasurment {
  final int? id;
  final int? userId;
  final String? data;
  final double? wartosc;

  WeightMeasurment({this.id, this.userId, this.data, this.wartosc});

  factory WeightMeasurment.fromMap(Map<String, dynamic> map) => WeightMeasurment(
    id: map[DbFields.massId],
    userId: map[DbFields.massUserId],
    data: map[DbFields.massDate],
    wartosc:
        map[DbFields.massValue] is int
            ? (map[DbFields.massValue] as int).toDouble()
            : map[DbFields.massValue],
  );

  Map<String, dynamic> toMap() => {
    DbFields.massUserId: userId,
    DbFields.massDate: data,
    DbFields.massValue: wartosc,
  };
}
