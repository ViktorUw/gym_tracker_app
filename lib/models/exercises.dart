import 'package:gym_tracker_app/services/db_fields.dart';

class Cwiczenia {
  final int? id;
  final String? nazwa;
  final String? opis;
  final String? grupaMiesniowa;
  final String? gifUrl;

  Cwiczenia({this.id, this.nazwa, this.opis, this.grupaMiesniowa, this.gifUrl});

  factory Cwiczenia.fromMap(Map<String, dynamic> map) => Cwiczenia(
    id: map['id_cwiczenia'],
    nazwa: map['nazwa_cwiczenia'],
    opis: map['opis_cwiczenia'],
    grupaMiesniowa: map['grupa_miesniowa'],
    gifUrl: map['gif_url'],
  );

  Map<String, dynamic> toMap() => {
    DbFields.exerciseId : id,
    DbFields.exerciseName: nazwa,
    DbFields.exerciseDesc: opis,
    DbFields.exerciseMuscleGroup: grupaMiesniowa,
    DbFields.exerciseGif: gifUrl,
  };
}
