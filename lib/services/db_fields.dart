class DbFields {
  // User
  static const tableUser = 'User';
  static const userId = 'user_id';
  static const userName = 'first_name';
  static const userSurname = 'last_name';
  static const userAge = 'age';
  static const userHeight = 'height';

  // Exercises
  static const tableExercise = 'Exercises';
  static const exerciseId = 'exercise_id';
  static const exerciseName = 'exercise_name';
  static const exerciseDesc = 'exercise_description';
  static const exerciseMuscleGroup = 'muscle_group';
  static const exerciseGif = 'gif_url';

  // Training Plans
  static const tablePlan = 'TrainingPlans';
  static const planId = 'plan_id';
  static const planName = 'plan_name';
  static const planDesc = 'plan_description';

  // Completed Trainings
  static const tableTraining = 'CompletedTrainings';
  static const trainingId = 'training_id';
  static const trainingUserId = 'user_id';
  static const trainingDate = 'training_date';
  static const trainingPlanId = 'plan_id';
  static const trainingDuration = 'duration';
  static const trainingVolume = 'volume';

  // Mass Measurements
  static const tableMass = 'WeightMeasurments';
  static const massId = 'id';
  static const massUserId = 'user_id';
  static const massDate = 'date';
  static const massValue = 'value';

  // Plan_Exercise
  static const tablePlanExercise = 'Plan_Exercise';
  static const planExercisePlanId = 'plan_id';
  static const planExerciseExerciseID = 'exercise_id';

  // Completed Exercises
  static const tableExerciseDone = 'CompletedExercises';
  static const exerciseDoneId = 'id';
  static const exerciseDoneTrainingId = 'training_id';
  static const exerciseDoneExerciseId = 'exercise_id';
  static const exerciseDoneWeight = 'weight';
  static const exerciseDoneReps = 'reps';
  static const exerciseDone1RM = 'one_rm';
}
