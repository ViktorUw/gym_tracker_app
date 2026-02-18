import 'package:gym_tracker_app/services/db_fields.dart';

class TrainingPlans {
  final int? plan_id;
  final String? plan_name;
  final String? planDescription;

  TrainingPlans({this.plan_id, this.plan_name, this.planDescription});

  factory TrainingPlans.fromMap(Map<String, dynamic> map) {
    return TrainingPlans(

      plan_id: map[DbFields.planId],
      plan_name: map[DbFields.planName],
      planDescription: map[DbFields.planDesc] 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DbFields.planId: plan_id,
      DbFields.planName: plan_name,
      DbFields.planDesc: planDescription,
    };
  }

  TrainingPlans copyWith({int? id, String? nazwaPlanu, String? opisPlanu}) {
    return TrainingPlans(
      plan_id: id ?? this.plan_id,
      plan_name: nazwaPlanu ?? this.plan_name,
      planDescription: opisPlanu ?? this.planDescription,
    );
  }
  
}
