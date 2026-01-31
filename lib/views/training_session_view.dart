import 'package:flutter/material.dart';
import 'package:gym_tracker_app/models/exercise_done.dart';
import 'package:gym_tracker_app/views/training_summary_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:gym_tracker_app/models/training_plans.dart';
import 'package:gym_tracker_app/view_models/exercise_view_model.dart';
import 'package:gym_tracker_app/view_models/user_view_model.dart';
import 'package:gym_tracker_app/repositories/training_done_repository.dart';
import 'package:gym_tracker_app/views/each_training_view.dart';

class SetData {
  bool isCompleted;
  TextEditingController weightCtrl;
  TextEditingController repsCtrl;

  SetData({
    this.isCompleted = false,
    required this.weightCtrl,
    required this.repsCtrl,
  });

  void dispose() {
    weightCtrl.dispose();
    repsCtrl.dispose();
  }

  double? getVolume() {
    final w = double.tryParse(weightCtrl.text);
    final r = int.tryParse(repsCtrl.text);
    if (w != null && r != null) return w * r;
    return null;
  }

  /// 1eRM (Epley): 1RM = weight * (1 + reps/30)
  double? get1eRM() {
    final w = double.tryParse(weightCtrl.text);
    final r = int.tryParse(repsCtrl.text);

    if (w == null || r == null) return null;
    if (w <= 0 || r <= 0) return null;

    return w * (1.0 + r / 30.0);
  }
}

class TrainingSessionView extends StatefulWidget {
  final String trainingName;
  final double startingWeight;
  final TrainingPlans plan;

  const TrainingSessionView({
    Key? key,
    required this.trainingName,
    required this.startingWeight,
    required this.plan,
  }) : super(key: key);

  @override
  State<TrainingSessionView> createState() => _TrainingSessionViewState();
}

class _TrainingSessionViewState extends State<TrainingSessionView>
    with TickerProviderStateMixin {
  late Stopwatch _stopwatch;
  late AnimationController _timerController;
  int _currentExerciseIndex = 0;
  late Map<int, List<SetData>> _completedSets;
  late VideoPlayerController _videoController;
  bool _videoInitialized = false;

  final TrainingDoneRepository _trainingRepo = TrainingDoneRepository();
  int? _lastTrainingId;
  bool _loadingLastTraining = false;

  @override
  void initState() {
    super.initState();
    _completedSets = {};
    _stopwatch = Stopwatch()..start();

    _timerController = AnimationController(
      duration: const Duration(hours: 24),
      vsync: this,
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final vm = Provider.of<ExercisesViewModel>(context, listen: false);

      vm.loadExercisesForPlan(widget.plan.id!).then((_) async {
        if (!mounted) return;

        await _loadLastTrainingId();

        if (vm.cwiczeniaWPlanie.isNotEmpty) {
          _initializeVideo(vm.cwiczeniaWPlanie[0]);
          _addFirstSet();
        }
      });
    });
  }

  Future<void> _loadLastTrainingId() async {
    final userVm = Provider.of<UserViewModel>(context, listen: false);
    final userId = userVm.user?.id;
    final planId = widget.plan.id;

    if (userId == null || planId == null) return;

    setState(() => _loadingLastTraining = true);
    try {
      final last = await _trainingRepo.getLastTrainingForPlan(
        userId: userId,
        planId: planId,
      );
      if (!mounted) return;
      setState(() => _lastTrainingId = last?.id);
    } finally {
      if (mounted) setState(() => _loadingLastTraining = false);
    }
  }

  void _addFirstSet() {
    if (!_completedSets.containsKey(_currentExerciseIndex)) {
      _completedSets[_currentExerciseIndex] = [];
    }
    if (_completedSets[_currentExerciseIndex]!.isEmpty) {
      _completedSets[_currentExerciseIndex]!.add(
        SetData(
          weightCtrl: TextEditingController(),
          repsCtrl: TextEditingController(),
        ),
      );
    }
  }

  void _initializeVideo(dynamic exercise) {
    if (exercise.gifUrl == null || exercise.gifUrl!.isEmpty) return;

    _videoController =
        VideoPlayerController.asset('assets/videos/${exercise.gifUrl}.mp4')
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _videoInitialized = true;
              });
              _videoController.play();
            }
          });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timerController.dispose();
    for (final exerciseSets in _completedSets.values) {
      for (final setData in exerciseSets) {
        setData.dispose();
      }
    }
    if (_videoInitialized) {
      _videoController.dispose();
    }
    super.dispose();
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      if (!_completedSets.containsKey(exerciseIndex)) {
        _completedSets[exerciseIndex] = [];
      }
      _completedSets[exerciseIndex]!.add(
        SetData(
          weightCtrl: TextEditingController(),
          repsCtrl: TextEditingController(),
        ),
      );
    });
  }

  void _removeSet(int exerciseIndex, int setIndex) {
    setState(() {
      _completedSets[exerciseIndex]![setIndex].dispose();
      _completedSets[exerciseIndex]!.removeAt(setIndex);
    });
  }

  void _toggleSetCompletion(int exerciseIndex, int setIndex) {
    setState(() {
      _completedSets[exerciseIndex]![setIndex].isCompleted =
          !_completedSets[exerciseIndex]![setIndex].isCompleted;
    });
  }

  void _nextExercise() {
    final vm = Provider.of<ExercisesViewModel>(context, listen: false);
    if (_currentExerciseIndex < vm.cwiczeniaWPlanie.length - 1) {
      setState(() => _currentExerciseIndex++);

      if (_videoInitialized) {
        _videoController.dispose();
        _videoInitialized = false;
      }

      _initializeVideo(vm.cwiczeniaWPlanie[_currentExerciseIndex]);
      _addFirstSet();
    }
  }

  void _previousExercise() {
    final vm = Provider.of<ExercisesViewModel>(context, listen: false);
    if (_currentExerciseIndex > 0) {
      setState(() => _currentExerciseIndex--);

      if (_videoInitialized) {
        _videoController.dispose();
        _videoInitialized = false;
      }

      _initializeVideo(vm.cwiczeniaWPlanie[_currentExerciseIndex]);
    }
  }

  double _calculateTotalVolume() {
    double total = 0;
    for (final sets in _completedSets.values) {
      for (final set in sets) {
        final vol = set.getVolume();
        if (vol != null) total += vol;
      }
    }
    return total;
  }

  Future<void> _cancelTraining() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Anulować trening?'),
            content: const Text(
              'Czy na pewno chcesz anulować trening? Wszystkie niezapisane dane zostaną utracone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Nie'),
              ),
              TextButton(
                onPressed:
                    () => Navigator.of(ctx).popUntil((route) => route.isFirst),
                child: const Text('Tak'),
              ),
            ],
          ),
    );

    if (confirm == true && mounted) {
      _stopwatch.stop();
      Navigator.of(context).pop();
    }
  }

  Future<void> _finishTraining() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Center(
              child: Icon(
                Icons.fitness_center,
                color: Color(0xFFFFB800),
                size: 100,
              ),
            ),
            content: const Text('Chcesz skończyć trening?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Nie'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Tak'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    if (!mounted) return;
    _stopwatch.stop();

    final totalVolume = _calculateTotalVolume();
    final duration = _stopwatch.elapsed;
    final formattedTime = _formatTime(duration);

    final userVm = Provider.of<UserViewModel>(context, listen: false);
    final vm = Provider.of<ExercisesViewModel>(context, listen: false);

    final List<ExerciseDone> done = [];
    for (final entry in _completedSets.entries) {
      final exerciseIndex = entry.key;
      if (exerciseIndex < 0 || exerciseIndex >= vm.cwiczeniaWPlanie.length) {
        continue;
      }
      final exercise = vm.cwiczeniaWPlanie[exerciseIndex];
      final cwiczenieId = exercise.id;

      for (final set in entry.value) {
        final w = double.tryParse(set.weightCtrl.text);
        final r = int.tryParse(set.repsCtrl.text);
        if (w != null && r != null) {
          final oneErm = (w > 0 && r > 0) ? (w * (1.0 + r / 30.0)) : null;

          done.add(
            ExerciseDone(
              id: null,
              treningId: null,
              cwiczenieId: cwiczenieId,
              waga: w,
              iloscPowtorzen: r,
              oneRM: oneErm
            ),
          );
        }

      }
    }

    final saved = await userVm.saveTreningWykonany(
      planId: widget.plan.id!,
      trainingName: widget.trainingName,
      startWeight: widget.startingWeight,
      durationSeconds: duration.inSeconds,
      totalVolume: totalVolume,
      completedExercises: done,
    );

    if (!saved) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Błąd zapisu treningu')));
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => TrainingSummaryView(
              trainingName: widget.trainingName,
              trainingDate: DateTime.now().toIso8601String(),
              duration: formattedTime,
              totalVolume: totalVolume,
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
        elevation: 0,
        title: Text(widget.trainingName),
        actions: [
          if (_loadingLastTraining)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              tooltip: 'Poprzedni trening',
              icon: const Icon(Icons.history),
              onPressed:
                  (_lastTrainingId == null)
                      ? null
                      : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => EachTrainingView(
                                  trainingId: _lastTrainingId!,
                                ),
                          ),
                        );
                      },
            ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<int>(
                stream: Stream.periodic(
                  const Duration(seconds: 1),
                  (_) => _stopwatch.elapsedMilliseconds,
                ),
                builder: (context, snapshot) {
                  return Text(
                    _formatTime(
                      Duration(milliseconds: _stopwatch.elapsedMilliseconds),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ExercisesViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.cwiczeniaWPlanie.isEmpty) {
            return const Center(
              child: Text(
                'Brak ćwiczeń w planie',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final exercise = vm.cwiczeniaWPlanie[_currentExerciseIndex];
          final sets = _completedSets[_currentExerciseIndex] ?? [];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Ćwiczenie ${_currentExerciseIndex + 1} / ${vm.cwiczeniaWPlanie.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value:
                          (_currentExerciseIndex + 1) /
                          vm.cwiczeniaWPlanie.length,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade700,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFFB800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Card(
                    color: const Color(0xFF23272A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.nazwa ?? 'Brak nazwy',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 240,
                            width: double.infinity,
                            color: const Color(0xFF23252B),
                            child:
                                _videoInitialized
                                    ? ClipRect(
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width:
                                              _videoController.value.size.width,
                                          height:
                                              _videoController
                                                  .value
                                                  .size
                                                  .height,
                                          child: VideoPlayer(_videoController),
                                        ),
                                      ),
                                    )
                                    : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            exercise.opis ?? 'Brak opisu',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Podejścia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _addSet(_currentExerciseIndex),
                        icon: const Icon(Icons.add),
                        label: const Text('Dodaj'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB800),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...sets.asMap().entries.map((entry) {
                    final setIndex = entry.key;
                    final setData = entry.value;
                    final volume = setData.getVolume();
                    final eRM = setData.get1eRM();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        color:
                            setData.isCompleted
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF424450),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Podejście ${setIndex + 1}',
                                    style: TextStyle(
                                      color:
                                          setData.isCompleted
                                              ? Colors.white
                                              : Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap:
                                            () => _toggleSetCompletion(
                                              _currentExerciseIndex,
                                              setIndex,
                                            ),
                                        child:
                                            setData.isCompleted
                                                ? const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                )
                                                : const Icon(
                                                  Icons.radio_button_unchecked,
                                                  color: Colors.white54,
                                                ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (sets.length > 1)
                                        GestureDetector(
                                          onTap:
                                              () => _removeSet(
                                                _currentExerciseIndex,
                                                setIndex,
                                              ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: setData.weightCtrl,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Waga (kg)',
                                        labelStyle: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                        filled: true,
                                        fillColor: Colors.black26,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                      ),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: setData.repsCtrl,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Powtórzenia',
                                        labelStyle: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                        filled: true,
                                        fillColor: Colors.black26,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                      ),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              if (volume != null || eRM != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (volume != null)
                                      Text(
                                        'Volume: ${volume.toStringAsFixed(1)}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      )
                                    else
                                      const SizedBox.shrink(),

                                    if (eRM != null)
                                      Text(
                                        '1eRM: ${eRM.toStringAsFixed(1)}',
                                        style: const TextStyle(
                                          color: Color(0xFFFFB800),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    else
                                      const SizedBox.shrink(),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _currentExerciseIndex > 0
                                  ? _previousExercise
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Poprzednie'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _currentExerciseIndex <
                                      vm.cwiczeniaWPlanie.length - 1
                                  ? _nextExercise
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB800),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Następne'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Builder(
                    builder: (context) {
                      final isLastExercise =
                          vm.cwiczeniaWPlanie.isNotEmpty &&
                          _currentExerciseIndex ==
                              vm.cwiczeniaWPlanie.length - 1;

                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _cancelTraining,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                'Anuluj trening',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  isLastExercise ? _finishTraining : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                'Zakończ trening',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}