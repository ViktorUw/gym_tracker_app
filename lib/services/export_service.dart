import 'package:gym_tracker_app/repositories/exercise_done_repository.dart';
import 'package:gym_tracker_app/repositories/training_done_repository.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/db_fields.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'dart:io';

class ExportService {
  static Future<void> _writeCsvUtf8WithBom(File file, String content) async {
    final bytes = <int>[0xEF, 0xBB, 0xBF, ...utf8.encode(content)];
    await file.writeAsBytes(bytes, flush: true);
  }

  static Future<File> exportTrainingDetailsToCSV(int trainingId) async {
    final repoTreningWykonany = TrainingDoneRepository();
    final repoCwiczenieWykonane = ExerciseDoneRepository();

    final res1 = await repoTreningWykonany.getTrainingSummaryById(trainingId);
    final res2 = await repoCwiczenieWykonane.getSetsForTraining(trainingId);

    final buffer = StringBuffer();
    buffer.writeln("Nazwa Treningu;Data Wykonania;Objętość;Czas Trwania");
    buffer.writeln(
      "${res1!.trainingName};${res1.trainingDate};${res1.totalVolume};${res1.duration}",
    );

    buffer.writeln("Cwiczenie;Waga;Ilość powtórzeń;1RM");
    for (final r in res2) {
      buffer.writeln(
        "${r['exercise_name']};${r['weight']};${r['reps']};${r['one_rm']}",
      );
    }

    final dir = await getTemporaryDirectory();
    final fileName =
        "Trening_${res1.trainingName}_${DateTime.now().toIso8601String().replaceAll(':', '-')}.csv";
    final file = File("${dir.path}/$fileName");
    await file.writeAsString(buffer.toString(), flush: true);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: "Esport Danych Treningowych (CSV)");
    return file;
  }

  static Future<File> exportMassToCsvAndShare() async {
    final db = await DatabaseServices.instance.database;
    final rows = await db.query(
      DbFields.tableMass,
      orderBy: "${DbFields.massDate} ASC",
    );

    final buffer = StringBuffer();
    buffer.writeln("id_uzytkownika;data;wartosc");

    for (final r in rows) {
      buffer.writeln(
        "${r[DbFields.massUserId]};${r[DbFields.massDate]};${r[DbFields.massValue]}",
      );
    }

    final dir = await getTemporaryDirectory();
    final fileName =
        "waga_${DateTime.now().toIso8601String().replaceAll(':', '-')}.csv";
    final file = File("${dir.path}/$fileName");
    await _writeCsvUtf8WithBom(file, buffer.toString());

    await Share.shareXFiles([XFile(file.path)], text: "Eksport wagi (CSV)");

    return file;
  }
}
