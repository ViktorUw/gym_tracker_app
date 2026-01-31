import 'package:gym_tracker_app/services/db_fields.dart';
class User {
  final int? id;
  final String? imie;
  final String? nazwisko;
  final int? wiek;
  final double? wzrost;
  final double? waga;

  User({this.id, this.imie, this.nazwisko, this.wiek, this.wzrost, this.waga});

  factory User.fromMap(Map<String, dynamic> map, {double? waga}) => User(
    id: map['id_uzytkownika'],
    imie: map['imie'],
    nazwisko: map['nazwisko'],
    wiek: map['wiek'],
    wzrost: map['wzrost'],
    waga: waga,
  );

  Map<String, dynamic> toMap() => {
    DbFields.userId : id,
    DbFields.userName : imie,
    DbFields.userSurname : nazwisko,
    DbFields.userAge : wiek,
    DbFields.userHeight : wzrost,
  };
}
