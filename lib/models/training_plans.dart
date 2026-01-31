import 'package:gym_tracker_app/services/db_fields.dart';

class TrainingPlans {
  final int? id;
  final String? nazwaPlanu;
  final String? opisPlanu;

  TrainingPlans({this.id, this.nazwaPlanu, this.opisPlanu});

  factory TrainingPlans.fromMap(Map<String, dynamic> map) {
    return TrainingPlans(

      id: map[DbFields.planId],
      nazwaPlanu: map[DbFields.planName],
      opisPlanu: map[DbFields.planDesc] 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DbFields.planId: id,
      DbFields.planName: nazwaPlanu,
      DbFields.planDesc: opisPlanu,
    };
  }

  TrainingPlans copyWith({int? id, String? nazwaPlanu, String? opisPlanu}) {
    return TrainingPlans(
      id: id ?? this.id,
      nazwaPlanu: nazwaPlanu ?? this.nazwaPlanu,
      opisPlanu: opisPlanu ?? this.opisPlanu,
    );
  }
  
}
