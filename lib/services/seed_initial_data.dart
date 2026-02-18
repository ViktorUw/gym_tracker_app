import 'package:gym_tracker_app/models/exercises.dart';
import 'package:gym_tracker_app/models/plan_exercise.dart';
import 'package:gym_tracker_app/models/training_plans.dart';
import 'package:gym_tracker_app/repositories/exercise_repository.dart';
import 'package:gym_tracker_app/repositories/plan_exercise_repository.dart';
import 'package:gym_tracker_app/repositories/plan_repository.dart';

Future<void> seedInitialData() async {
  final exerciseRepo = ExerciseRepository();
  final planRepo = PlanRepository();
  final planCwiczenieRepo = PlanExerciseRepository();

  final exercises = await exerciseRepo.getAllExercises();
  if (exercises.isEmpty) {
    // Plecy
    final idCw1 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Ciągnięcie górnego bloku',
        exerciseDescription:
            'Ustaw się w odpowiedniej pozycji siedzącej, zachowując prostą plecy i stopy płasko na podłodze.',
        muscleGroup: 'plecy',
        gifUrl: 'ciagniecie_gornego_bloku',
      ),
    );

    final idCw2 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Wiosłowanie na maszynie na plecy',
        exerciseDescription:
            'Usiądź na maszynie do wiosłowania, upewniając się, że plecy są proste, a nogi są stabilnie umieszczone. Chwytaj za uchwyty lub trzymaj rękojeści, nachylając się w pasie i trzymając ręce przed sobą. Napnij mięśnie pleców, przyciągnij ręce do tyłu, opuszczając ramiona w dół i prostując łopatki. Powoli wróć do pozycji wyjściowej, kontrolując ruch i utrzymując napięcie w mięśniach pleców. Powtórz określoną liczbę powtórzeń, dbając o prawidłową formę i kontrolę nad ruchem.',
        muscleGroup: 'plecy',
        gifUrl: 'wioslowanie_na_plecy',
      ),
    );

    final idCw3 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Wiosłowanie w opadzie',
        exerciseDescription:
            'Stój prosto, trzymając sztangę na wyciągniętych rękach, opuszczając ją przed sobą. Zegnij w pasie, lekko zginając kolana i utrzymując prostą plecy. Pociągnij sztangę do góry, unosząc łokcie i napinając mięśnie pleców. Opuszczaj sztangę powoli, kontrolując ruch, aby wróciła do pozycji wyjściowej. Powtórz określoną liczbę powtórzeń, utrzymując stabilność ciała i kontrolując oddech.',
        muscleGroup: 'plecy',
        gifUrl: 'wioslowanie_w_opadzie',
      ),
    );

    // Piers
    final idCw4 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Uginanie ramion w maszynie na klatkę piersiową',
        exerciseDescription:
            'Usiądź na maszynie z odpowiednio ustawionym obciążeniem i regulowanymi poduszkami, tak aby były przylegające do klatki piersiowej.',
        muscleGroup: 'piers',
        gifUrl: 'uginanie_na_klate',
      ),
    );

    final idCw5 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Wyciskanie na górnej części klatki piersiowej',
        exerciseDescription:
            'Połóż się na ławeczce, trzymając sztangę lub hantle nad klatką piersiową, ręce na szerokości barków. Wykonaj wdech i opuść sztangę lub hantle powoli ku górze, aż dotkną one górnej części klatki piersiowej. Wykonaj wydech i wyciśnij sztangę lub hantle w górę, prostując ramiona, ale nie zamykaj ich całkowicie na górze, aby utrzymać napięcie w mięśniach. Powtórz ruch przez określoną liczbę powtórzeń, dbając o kontrolę nad ciężarem i zachowując stabilność ciała.',
        muscleGroup: 'piers',
        gifUrl: 'wyciskanie_na_gore_klaty',
      ),
    );
    

    final idCw6 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Wyciskanie na maszynie siedząc',
        exerciseDescription:
            'Usiądź wygodnie na maszynie, tak aby poduszki dobrze podtrzymywały plecy i ramiona. Ustaw rękojeści na poziomie klatki piersiowej i chwytaj za nie, trzymając je zwrócone do ciebie. Wykonaj wydech i wypchnij rękojeści do przodu, napinając mięśnie klatki piersiowej. Wdychaj, wracając powoli z rękojeściami do pozycji wyjściowej, kontrolując ruch. Powtarzaj ćwiczenie przez określoną liczbę powtórzeń, utrzymując stabilność i kontrolując ruch.',
        muscleGroup: 'piers',
        gifUrl: 'wyciskanie_na_maszynie_siedzac',
      ),
    );

    // Ramiona
    final idCw7 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Wyciskanie na barki siedząc',
        exerciseDescription:
            'Usiądź na ławce z podporami na sztangę na wysokości ramion. Umieść sztangę na podporach na wysokości ramion. Połóż się na plecach, złap sztangę szerokim uchwytem i ostrożnie zdejmij ją z podpór. Prostując ramiona, podnieś sztangę do góry, trzymając ją nad głową. Powoli opuść sztangę, zginając łokcie, aż dotknie ramion. Podnieś sztangę do góry, prostując ramiona, i powtórz to ćwiczenie przez określoną liczbę powtórzeń, dbając o prawidłową formę i kontrolę nad ruchem.',
        muscleGroup: 'ramiona',
        gifUrl: 'wyciskanie_na_barki',
      ),
    );

    final idCw8 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Unoszenie hantli na boki',
        exerciseDescription:
            'Stań prosto, trzymając hantle wzdłuż ciała, dłonie skierowane ku dołowi. Wykonaj wdech i unieś hantle na boki, trzymając lekko zgięte łokcie i utrzymując stabilność tułowia. Unosząc hantle, skoncentruj się na napięciu mięśni bocznych deltojdów. Wykonaj wydech i powoli opuść hantle do pozycji wyjściowej, kontrolując ruch. Powtórz określoną liczbę powtórzeń, dbając o kontrolę nad ciężarem i zachowując stabilność ciała.',
        muscleGroup: 'ramiona',
        gifUrl: 'unoszenie_hantli_na_boki',

      ),
    );

    final idCw9 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Wyciskanie sztangi w Smith machine',
        exerciseDescription:
            'Ustaw sztangę na odpowiedniej wysokości na maszynie Smitha i dodaj obciążenie. Stój prosto pod sztangą, stopy szerokość barków, trzymając sztangę na poziomie barków. Wdychaj i wypychaj sztangę do góry, prostując ramiona, ale nie blokując ich całkowicie na górze. Powoli opuszczaj sztangę, kontrolując ruch, aby wróciła do pozycji wyjściowej. Powtórz określoną liczbę powtórzeń, dbając o kontrolę nad ciężarem i zachowując stabilność ciała.',
        muscleGroup: 'ramiona',
        gifUrl: 'wyciskanie_w_smit_maszynie',
      ),
    );

    // Triceps
    final idCw10 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Prostowanie na triceps',
        exerciseDescription:
            'Usiądź na ławeczce, trzymając sztangę nad głową ramionami na szerokości barków. Zegnij łokcie, opuszczając sztangę za głowę, zachowując pionowe ułożenie przedramion. Wyprostuj łokcie, unosząc sztangę z powrotem do pozycji wyjściowej, przeciwstawiając się sile grawitacji. Kontroluj ruch i unikaj całkowitego zablokowania łokci w górnej pozycji. Powtórz ćwiczenie określoną liczbę razy, utrzymując dobrą formę i kontrolując oddech.',
        muscleGroup: 'triceps',
        gifUrl: 'prostowanie_na_triceps',
      ),
    );

    final idCw11 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Pompowanie od ławy na tricepsa',
        exerciseDescription:
            'Połóż się na płaskiej ławce na brzuchu, z rękami umieszczonymi na podłodze nieco szerzej niż szerokość ramion. Wypchnij się z rąk, prostując ramiona, ale nie blokując ich całkowicie na górze, aby utrzymać napięcie w tricepsie. Opuszczaj ciało, zginając łokcie, aż twoja klatka piersiowa zbliży się do podłogi. Wróć do pozycji wyjściowej, naciskając dłonie w podłogę, aby unieść ciało do góry. Powtórz określoną liczbę powtórzeń, utrzymując kontrolę nad ruchem i zachowując stabilność ciała.',
        muscleGroup: 'triceps',
        gifUrl: 'pompowanie_od_lawy',
      ),
    );

    final idCw12 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Wyciskanie wąskim chwytem',
        exerciseDescription:
            'Usiądź na ławeczce lub połóż się na skamieniu, trzymając sztangę wąskim chwytem (tj. ręce blisko siebie). Podnieś sztangę do góry, trzymając ją nad klatką piersiową, z łokciami skierowanymi do przodu. Powoli opuść sztangę w dół, kontrolując ruch, aż dotknie ona klatki piersiowej. Następnie wyprostuj ramiona, unosząc sztangę do góry, ale nie blokując ich całkowicie. Powtórz określoną liczbę powtórzeń, zachowując kontrolę nad ciężarem i stabilność ciała.',
        muscleGroup: 'triceps',
        gifUrl: 'wyciskanie_waskim_uchwytem',
      ),
    );

    // Biceps
    final idCw13 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Podciąganie na biceps',
        exerciseDescription:
            'Stój prosto, trzymając sztangę lub hantle na wyciągniętych rękach, opuszczając je wzdłuż ciała. Zegnij łokcie, unosząc sztangę lub hantle ku górze, skupiając się na skurczu mięśni bicepsów. Powoli opuść sztangę lub hantle, kontrolując ruch, aby uniknąć nadmiernego rozciągania mięśni. Powtórz określoną liczbę razy, utrzymując stabilność ciała i kontrolując oddech.',
        muscleGroup: 'biceps',
        gifUrl: 'podciaganie_na_biceps',
      ),
    );

    final idCw14 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Podnoszenie hantli na biceps siedząc',
        exerciseDescription:
            'Usiądź na ławeczce z hantlami w rękach, ramiona wzdłuż tułowia, dłonie zwrócone do ciała. Wykonaj wdech i podnieś hantle ku górze, zginając łokcie i skupiając się na skurczu mięśni bicepsów. Unosząc hantle, unikaj ruchu ramion, skupiając się na pracy wyłącznie bicepsów. Wykonaj wydech i powoli opuść hantle do pozycji wyjściowej, kontrolując ruch. Powtórz określoną liczbę powtórzeń, dbając o kontrolę nad ciężarem i zachowując stabilność ciała.',
        muscleGroup: 'biceps',
        gifUrl: 'podnoszenie_hantli_na_biceps',
      ),
    );

    final idCw15 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Podnoszenie hantli młotkowato',
        exerciseDescription:
            'Stań prosto, trzymając hantle wzdłuż ciała, dłonie zwrócone ku sobie. Wykonaj wdech i unieś hantle ku górze, przytrzymując je wzdłuż ciała, zgięte łokcie. Skoncentruj się na napięciu mięśni ramion, unikając ruchu nadgarstków. Wykonaj wydech i powoli opuść hantle, wracając do pozycji wyjściowej. Powtórz określoną liczbę powtórzeń, dbając o kontrolę nad ciężarem i zachowując stabilność ciała.',
        muscleGroup: 'biceps',
        gifUrl: 'podnoszenie_hantli_mlotkiem',
      ),
    );

    // Nogi
    final idCw16 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Wyciskanie nóg',
        exerciseDescription:
            'Połóż się na plecach na ławce do wyciskania nóg, upewniając się, że ramiona i plecy są dobrze przylegające do poduszki. Umieść stopy na platformie szeroko na szerokość ramion, zgięte kolana pod kątem około 90 stopni. Zwolnij blokadę i ostrożnie odpychaj platformę stopami, wypychając ją do przodu. Wyprostuj nogi, rozszerzając kolana, a następnie powoli je zgiń, opuszczając platformę z powrotem do pozycji wyjściowej. Powtarzaj ćwiczenie przez określoną liczbę powtórzeń, utrzymując kontrolę i właściwą formę.',
        muscleGroup: 'nogi',
        gifUrl: 'wyciskanie_nogami',
      ),
    );

    final idCw17 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Rozpętki łytek siedząc',
        exerciseDescription:
            'Usiądź na ławeczce ze sztangielkami na kolanach lub specjalnym sprzęcie do rozpiętek łydek. Powoli opuść stopy, kontrolując ruch, aż wrócą do pozycji wyjściowej. Powtórz określoną liczbę powtórzeń, dbając o kontrolę nad ciężarem i zachowując stabilność ciała.',
        muscleGroup: 'nogi',
        gifUrl: 'rozpetki_lytek',
      ),
    );

    final idCw18 = await exerciseRepo.insertExercise(
      Exercises(
        exerciseName: 'Przysiady na maszynie hack',
        exerciseDescription:
            'Ustaw ławeczkę lub platformę na odpowiedniej wysokości na maszynie hack. Stań prosto na platformie, barki i plecy przylegające do podparcia. Umieść stopy na platformie na szerokość barków lub nieco szerzej. Wykonaj wdech i powoli opuść się w dół, zginając kolana, aż uda znajdą się w pozycji równoległej do podłogi lub nieco niżej. Wykonaj wydech i wypchnij się w górę, prostując nogi, ale nie zamykaj ich całkowicie na górze. Powtórz określoną liczbę powtórzeń, dbając o kontrolę nad ruchem i zachowując stabilność ciała.',
        muscleGroup: 'nogi',
        gifUrl: 'przysiady_na_maszynie',
      ),
    );

    final plans = await planRepo.getAllPlans();
    if (plans.isEmpty) {
      final id1 = await planRepo.insertPlan(
        TrainingPlans(
          plan_name: 'FB Poniedziałek',
          planDescription: 'Full Body training dla mięśni całego ciała w poniedzałek',
        ),
      );

      final id2 = await planRepo.insertPlan(
        TrainingPlans(
          plan_name: 'FB Sroda',
          planDescription: 'Full Body training dla mięśni całego ciała w środę',
        ),
      );

      final id3 = await planRepo.insertPlan(
        TrainingPlans(
          plan_name: 'FB Piątek',
          planDescription: 'Full Body training dla mięśni całego ciała w piątek',
        ),
      );

      final plans_exercises = await planCwiczenieRepo.getAllPlanExercises();
      if (plans_exercises.isEmpty) {
        // FB Monday
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id1, exerciseId: idCw1),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id1, exerciseId: idCw4),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id1, exerciseId: idCw7),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id1, exerciseId: idCw10),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id1, exerciseId: idCw13),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id1, exerciseId: idCw16),
        );
        
        // FB Sroda
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id2, exerciseId: idCw2),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id2, exerciseId: idCw5),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id2, exerciseId: idCw8),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id2, exerciseId: idCw11),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id2, exerciseId: idCw14),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id2, exerciseId: idCw17),
        );

        // Fb piatek
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id3, exerciseId: idCw3),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id3, exerciseId: idCw6),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id3, exerciseId: idCw9),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id3, exerciseId: idCw12),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id3, exerciseId: idCw15),
        );
        await planCwiczenieRepo.insertPlanExercise(
          PlanExercise(planId: id3, exerciseId: idCw18),
        );
      }
    }
  }
}
