import 'package:flutter/material.dart';
import 'package:gym_tracker_app/models/training_plans.dart';
import 'package:gym_tracker_app/view_models/exercise_view_model.dart';
import 'package:gym_tracker_app/views/add_exercise_to_plan_view.dart';
import 'package:gym_tracker_app/views/exercise_detail_view.dart';
import 'package:gym_tracker_app/view_models/training_plans_view_model.dart';
import 'package:provider/provider.dart';

class EachPlanView extends StatefulWidget {
  final TrainingPlans plan;
  const EachPlanView({Key? key, required this.plan}) : super(key: key);

  @override
  State<EachPlanView> createState() => _EachPlanViewState();
}

class _EachPlanViewState extends State<EachPlanView> {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditingName = false;
  String _currentName = '';

  @override
  void initState() {
    super.initState();
    _currentName = widget.plan.nazwaPlanu ?? '';
    _nameController.text = _currentName;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final vm = Provider.of<ExercisesViewModel>(context, listen: false);
        vm.loadExercises();
        vm.loadExercisesForPlan(widget.plan.id!);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty || newName == _currentName) {
      setState(() => _isEditingName = false);
      return;
    }

    final vm = Provider.of<TrainingPlansViewModel>(context, listen: false);
    final success = await vm.updatePlanName(widget.plan.id!, newName);

    if (success) {
      if (!mounted) return;
      setState(() {
        _currentName = newName;
        _isEditingName = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Zmieniono nazwę planu')));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Błąd podczas zapisu')));
    }
  }

  Future<void> _confirmDelete() async {
    final should = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Usuń plan'),
            content: const Text(
              'Czy na pewno chcesz usunąć ten plan treningowy?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Anuluj'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Usuń'),
              ),
            ],
          ),
    );

    if (should != true) return;

    try {
      final vm = Provider.of<TrainingPlansViewModel>(context, listen: false);
      await vm.deletePlan(widget.plan.id!);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Plan usunięty')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd przy usuwaniu: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const protectedPlanNames = {
      'FB Poniedzialek',
      'FB Sroda',
      'FB Piątek',
    };

    final planName = widget.plan.nazwaPlanu ?? '';
    final isProtected = protectedPlanNames.contains(planName);

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFF31353C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF31353C),
        elevation: 0,

        title:
            _isEditingName
                ? SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _nameController,
                    autofocus: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Nazwa planu',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                )
                : Text(_currentName),
        actions: [
          if (!isProtected) ...[
            if (_isEditingName) ...[
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: _saveName,
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed:
                    () => setState(() {
                      _nameController.text = _currentName;
                      _isEditingName = false;
                    }),
              ),
            ] else ...[
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => setState(() => _isEditingName = true),
              ),
            ],
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child:
                    isProtected
                        ? ElevatedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Usuń plan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        )
                        : ElevatedButton.icon(
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Usuń plan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _confirmDelete,
                        ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child:
                    isProtected
                        ? ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Dodaj ćwiczenie'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB800),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: null,
                        )
                        : ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Dodaj ćwiczenie'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB800),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AddExerciseToPlanView(
                                        planId: widget.plan.id!,
                                      ),
                                ),
                              ),
                        ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Opis Planu:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.plan.opisPlanu ?? "Brak opisu",
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Ćwiczenia w planie",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<ExercisesViewModel>(
                builder: (context, vm, _) {
                  if (vm.isLoading)
                    return const Center(child: CircularProgressIndicator());
                  if (vm.error != null)
                    return Center(
                      child: Text(
                        "${vm.error}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    );
                  if (vm.cwiczeniaWPlanie.isEmpty)
                    return const Center(
                      child: Text(
                        "Brak ćwiczeń w planie",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );

                  return ListView.builder(
                    itemCount: vm.cwiczeniaWPlanie.length,
                    itemBuilder: (context, index) {
                      final exercise = vm.cwiczeniaWPlanie[index];

                      return Dismissible(
                        key: ValueKey(exercise.id ?? UniqueKey()),
                        direction:
                            isProtected
                                ? DismissDirection.none
                                : DismissDirection.startToEnd,

                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                                context: context,
                                builder:
                                    (ctx) => AlertDialog(
                                      title: const Text('Potwierdzenie'),
                                      content: const Text(
                                        'Usunąć ćwiczenie z tego planu?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.of(ctx).pop(false),
                                          child: const Text('Nie'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(ctx).pop(true),
                                          child: const Text('Tak'),
                                        ),
                                      ],
                                    ),
                              ) ??
                              false;
                        },
                        onDismissed: (direction) {
                          final vm = Provider.of<ExercisesViewModel>(
                            context,
                            listen: false,
                          );
                          vm
                              .removeExerciseFromPlan(
                                widget.plan.id!,
                                exercise.id!,
                              )
                              .then((success) {
                                if (!mounted) return;

                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (!mounted) return;
                                });
                              });
                        },
                        child: Card(
                          color: const Color(0xFF23272A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              exercise.nazwa ?? "Brak nazwy",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ExerciseDetailView(
                                          exercise: exercise,
                                        ),
                                  ),
                                ),
                          ),
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
