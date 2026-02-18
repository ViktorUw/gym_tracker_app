import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/views/training_session_view.dart';

void main() {

  test('Obliczenie 1RM wg wzoru Brzyckiego', () {
    double weight = 100.0;
    int reps = 5;
    final result = SetData.estimate1RMBrzycki(weight, reps);
    expect(result, closeTo(112.5, 0.1));
  });

}
