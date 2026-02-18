import 'package:gym_tracker_app/services/db_fields.dart';

class WeightMeasurment {
  final int? meaasurment_id;
  final int? userId;
  final String? date;
  final double? value;

  WeightMeasurment({this.meaasurment_id, this.userId, this.date, this.value});

  factory WeightMeasurment.fromMap(Map<String, dynamic> map) => WeightMeasurment(
    meaasurment_id: map[DbFields.massId],
    userId: map[DbFields.massUserId],
    date: map[DbFields.massDate],
    value:
        map[DbFields.massValue] is int
            ? (map[DbFields.massValue] as int).toDouble()
            : map[DbFields.massValue],
  );

  Map<String, dynamic> toMap() => {
    DbFields.massUserId: userId,
    DbFields.massDate: date,
    DbFields.massValue: value,
  };
}
