import 'package:flutter/material.dart';
import 'package:gym_tracker_app/models/completed_trainings.dart';
import 'package:gym_tracker_app/models/completed_exercise.dart';
import 'package:gym_tracker_app/repositories/training_done_repository.dart';
import 'package:gym_tracker_app/repositories/exercise_done_repository.dart';
import 'package:gym_tracker_app/repositories/exercise_repository.dart';
import 'package:gym_tracker_app/repositories/plan_repository.dart';
import 'package:gym_tracker_app/services/export_service.dart';

class EachTrainingView extends StatefulWidget {
  final int trainingId;

  const EachTrainingView({Key? key, required this.trainingId})
    : super(key: key);

  @override
  State<EachTrainingView> createState() => _EachTrainingViewState();
}

class _EachTrainingViewState extends State<EachTrainingView> {
  CompletedTraining? _training;
  List<CompletedExercise> _doneList = [];
  Map<int, String> _exerciseNames = {};
  String? _planName;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final treningRepo = TrainingDoneRepository();
      final doneRepo = ExerciseDoneRepository();
      final exerciseRepo = ExerciseRepository();
      final planRepo = PlanRepository();

      final trening = await treningRepo.getTrainingById(widget.trainingId);
      if (trening == null) {
        setState(() {
          _error = 'Nie odnaleziono treningu';
          _isLoading = false;
        });
        return;
      }

      final done = await doneRepo.getByTrainingId(widget.trainingId);

      final exerciseIds =
          done.map((d) => d.exerciseId).whereType<int>().toSet();

      final Map<int, String> names = {};

      for (final id in exerciseIds) {
        final ex = await exerciseRepo.getExerciseById(id);
        names[id] = ex?.exerciseName ?? 'Ćwiczenie #$id';
      }

      String? planName;
      if (trening.planId != null) {
        final plan = await planRepo.getPlanById(trening.planId!);
        planName = plan?.plan_name;
      }

      setState(() {
        _training = trening;
        _doneList = done;
        _exerciseNames = names;
        _planName = planName;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  

  Widget _buildHeader() {
    final dateStr = _training?.date ?? '';
    final durationSec = _training?.duration ?? 0;
    final durationMin = (durationSec / 60.0);
    final volume = _training?.volume ?? 0;

    String formattedDate = dateStr;
    try {
      if (dateStr.isNotEmpty) {
        final dt = DateTime.parse(dateStr).toLocal();
        formattedDate =
            '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
    } catch (_) {}

    return Card(
      color: const Color(0xFF23272A),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _planName ?? 'Trening',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              formattedDate,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon( 
                  Icons.monitor_weight_outlined,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 3),
                Text(
                  '${volume.toStringAsFixed(1)} kg',
                  style: const TextStyle(color: Colors.white70),
                ),
                
                const SizedBox(width: 16),
                Icon(
                  Icons.timer_outlined,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 3),
                Text(
                  '${durationMin.toStringAsFixed(1)} min',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF31353C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF31353C),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            color: const Color(0xFFFFB800),
            onPressed: () async {
              try {
                await ExportService.exportTrainingDetailsToCSV(widget.trainingId);
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Błąd eksportu: $e")));
              }
            },
            tooltip: 'Eksportuj dane wagi (CSV)',
          ),
        ],
        elevation: 0,
        title: const Text('Szczegóły treningu'),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white70),
                ),
              )
              : _doneList.isEmpty
              ? Center(
                child: Text(
                  'Brak zapisanych ćwiczeń',
                  style: const TextStyle(color: Colors.white70),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 8),
                    ..._buildExerciseSections(),
                  ],
                ),
              ),
    );
  }

  List<Widget> _buildExerciseSections() {
    final Map<int, List<CompletedExercise>> grouped = {};
    for (final item in _doneList) {
      final id = item.exerciseId ?? -1;
      grouped.putIfAbsent(id, () => []).add(item);
    }

    final sections = <Widget>[];
    for (final entry in grouped.entries) {
      final exId = entry.key;
      final sets = entry.value;
      final exName = _exerciseNames[exId] ?? 'Ćwiczenie #$exId';

      sections.add(
        Card(
          color: const Color(0xFF23272A),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "1RM",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                /// SETS
                ...sets.asMap().entries.map((id_cwWyk) {
                  final idx = id_cwWyk.key;
                  final czw_wyk = id_cwWyk.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        /// nr setu
                        SizedBox(
                          width: 22,
                          child: Text(
                            '${idx + 1}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(width: 12),

                        /// weight
                        Text(
                          czw_wyk.weight != null
                              ? '${czw_wyk.weight!.toStringAsFixed(1)} kg'
                              : '-',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 12),

                        /// reps
                        Text(
                          '${czw_wyk.reps ?? '-'} powt.',
                          style: const TextStyle(color: Colors.white),
                        ),

                        const Spacer(),

                        /// 1eRM
                        if (czw_wyk.oneRM != null)
                          Text(
                            '${czw_wyk.oneRM!.toStringAsFixed(1)} kg',
                            style: const TextStyle(
                              color: Color(0xFFFFB800),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      );
    }

    return sections;
  }
}
