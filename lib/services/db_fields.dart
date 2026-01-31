class DbFields {
  // Uzytkownik
  static const tableUser = 'Uzytkownik';
  static const userId = 'id_uzytkownika';
  static const userName = 'imie';
  static const userSurname = 'nazwisko';
  static const userAge = 'wiek';
  static const userHeight = 'wzrost';

  // Cwiczenia
  static const tableExercise = 'Cwiczenia';
  static const exerciseId = 'id_cwiczenia';
  static const exerciseName = 'nazwa_cwiczenia';
  static const exerciseDesc = 'opis_cwiczenia';
  static const exerciseMuscleGroup = 'grupa_miesniowa';
  static const exerciseGif = 'gif_url';

  // PlanyTreningowe
  static const tablePlan = 'PlanyTreningowe';
  static const planId = 'id_planu';
  static const planName = 'nazwa_planu';
  static const planDesc = 'opis_planu';

  // Treningi Wykonane
  static const tableTraining = 'TreningiWykonane';
  static const trainingId = 'id_treningu';
  static const trainingUserId = 'id_uzytkownika';
  static const trainingDate = 'data_treningu';
  static const trainingPlanId = 'id_planu';
  static const trainingDuration = 'czas_trwania';
  static const trainingVolume = 'objetosc';

  // PomiarMasy
  static const tableMass = 'PomiarMasy';
  static const massId = 'id';
  static const massUserId = 'id_uzytkownika';
  static const massDate = 'data';
  static const massValue = 'wartosc';

  //Plan_Cwiczenie
  static const tablePlanExercise = 'Plan_Cwiczenie';
  static const planExercisePlanId = 'id_planu';
  static const planExerciseExerciseID = 'id_cwiczenia';

  //Cwiczenia Wykonane
  static const tableExerciseDone = 'CwiczeniaWykonane';
  static const exerciseDoneId = 'id';
  static const exerciseDoneTrainingId = 'id_treningu';
  static const exerciseDoneExerciseId = 'id_cwiczenia';
  static const exerciseDoneWeight = 'waga';
  static const exerciseDoneReps = 'ilosc_powtorzen';
  static const exerciseDone1RM = 'oneRM';
}
