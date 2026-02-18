import 'package:flutter/material.dart';
import 'package:gym_tracker_app/repositories/plan_repository.dart';
import 'package:gym_tracker_app/repositories/training_done_repository.dart';
import 'package:gym_tracker_app/views/start_training_view.dart';
import 'package:gym_tracker_app/views/each_training_view.dart';

class MyTrainingsView extends StatefulWidget {
  @override
  _MyTrainingsViewState createState() => _MyTrainingsViewState();
}

class _MyTrainingsViewState extends State<MyTrainingsView> {
  late Future<List<_TreningDisplayData>> _treningiFuture;

  @override
  void initState() {
    super.initState();
    _treningiFuture = _fetchTreningiWithPlanName();
  }

  Future<void> _refreshTreningi() async {
    setState(() {
      _treningiFuture = _fetchTreningiWithPlanName();
    });
    await _treningiFuture;
  }

  Future<List<_TreningDisplayData>> _fetchTreningiWithPlanName() async {
    final treningi = await TrainingDoneRepository().getAllTrainings();
    final planRepo = PlanRepository();

    List<_TreningDisplayData> result = [];
    for (final tr in treningi) {
      final plan = await planRepo.getPlanById(tr.planId!);

      String formattedDate;
      DateTime? parsed;
      if (tr.date != null && tr.date!.isNotEmpty) {
        try {
          parsed = DateTime.parse(tr.date!).toLocal();
          formattedDate =
              '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')} ${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
        } catch (_) {
          formattedDate = tr.date!;
        }
      } else {
        formattedDate = '';
      }

      final double durationSeconds = tr.duration ?? 0;
      final double durationMinutes = durationSeconds / 60.0;

      result.add(
        _TreningDisplayData(
          tr.id,
          plan?.plan_name ?? '---',
          formattedDate,
          durationMinutes,
          tr.volume ?? 0,
          parsed,
        ),
      );
    }

    result.sort((a, b) {
      if (a.dateTime == null && b.dateTime == null) return 0;
      if (a.dateTime == null) return 1;
      if (b.dateTime == null) return -1;
      return b.dateTime!.compareTo(a.dateTime!);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF31353C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF31353C),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => StartTrainingView()));
                await _refreshTreningi();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Rozpocznij nowy trening'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<_TreningDisplayData>>(
                future: _treningiFuture,
                builder: (ctx, snapshot) {
                  final treningi = snapshot.data ?? [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Błąd podczas ładowania treningów',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  if (treningi.isEmpty) {
                    return const Center(
                      child: Text(
                        "Brak treningów",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: treningi.length,
                    itemBuilder: (context, index) {
                      final tr = treningi[index];
                      return Dismissible(
                        key: ValueKey(tr.id ?? UniqueKey()),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text('Usunąć trening?'),
                                  content: const Text(
                                    'Czy na pewno chcesz usunąć ten trening',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                      child: const Text('Nie'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                      child: const Text('Так'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirmed != true) return false;
                          if (tr.id != null) {
                            try {
                              await TrainingDoneRepository().deleteTraining(
                                tr.id!,
                              );
                              await _refreshTreningi();
                              return true;
                            } catch (e) {
                              return false;
                            }
                          }
                          return false;
                        },

                        child: InkWell(
                          onTap: () async {
                            if (tr.id != null) {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          EachTrainingView(trainingId: tr.id!),
                                ),
                              );
                              await _refreshTreningi();
                            }
                          },
                          child: _TreningCard(trening: tr),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreningDisplayData {
  final int? id;
  final String nazwa;
  final String data;
  final double czasTrwaniaMinutes;
  final double objetosc;
  final DateTime? dateTime;

  _TreningDisplayData(
    this.id,
    this.nazwa,
    this.data,
    this.czasTrwaniaMinutes,
    this.objetosc,
    this.dateTime,
  );
}

class _TreningCard extends StatelessWidget {
  final _TreningDisplayData trening;
  const _TreningCard({required this.trening});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF424450),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        title: Text(
          trening.nazwa,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle:
            trening.data.isNotEmpty
                ? Text(trening.data, style: const TextStyle(color: Colors.white))
                : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${trening.czasTrwaniaMinutes.toStringAsFixed(1)} min',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Text(
              '${trening.objetosc.toStringAsFixed(1)} kg',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
