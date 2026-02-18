import 'package:gym_tracker_app/services/db_fields.dart';
class User {
  final int? id;
  final String? first_name;
  final String? last_name;
  final int? age;
  final double? height;
  final double? weight;

  User({this.id, this.first_name, this.last_name, this.age, this.height, this.weight});

  factory User.fromMap(Map<String, dynamic> map, {double? weight}) => User(
    id: map[DbFields.userId],
    first_name: map[DbFields.userName],
    last_name: map[DbFields.userSurname],
    age: map[DbFields.userAge],
    height: map[DbFields.userHeight],
    weight: weight,
  );

  Map<String, dynamic> toMap() => {
    DbFields.userId : id,
    DbFields.userName : first_name,
    DbFields.userSurname : last_name,
    DbFields.userAge : age,
    DbFields.userHeight : height,
  };
}
