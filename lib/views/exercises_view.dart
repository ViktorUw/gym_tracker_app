import 'package:flutter/material.dart';
import 'package:gym_tracker_app/view_models/cwiczenia_view_model.dart';
import 'package:gym_tracker_app/views/exercise_detail_view.dart';
import 'package:provider/provider.dart';

class ExercisesView extends StatefulWidget {
  @override
  State<ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<ExercisesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      if (mounted) {
        final vm = Provider.of<CwiczeniaViewModel>(context, listen: false);
        vm.loadExercises();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31353C),
      appBar: AppBar(
        backgroundColor: Color(0xFF31353C),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<CwiczeniaViewModel>(
              builder: (context, vm, child) {
                return Column(
                  children: [
                    TextField(
                      onChanged: vm.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Szukaj ćwiczenia...',
                        filled: true,
                        fillColor: Color(0xFF2E3135),
                        prefixIcon: Icon(Icons.search, color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: vm.selectedGroup ?? 'Wszystkie',
                            items:
                                ['Wszystkie', ...vm.availableGroups].map((g) {
                                  return DropdownMenuItem(
                                    value: g,
                                    child: Text(
                                      g,
                                      style: TextStyle(color: Colors.white60),
                                    ),
                                  );
                                }).toList(),
                            onChanged:
                                (v) => vm.setSelectedGroup(
                                  v == 'Wszystkie' ? null : v,
                                ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF2E3135),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                            ),
                            dropdownColor: Color(0xFF424450),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            vm.setSearchQuery('');
                            vm.setSelectedGroup(null);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),

            Consumer<CwiczeniaViewModel>(
              builder: (context, value, child) {
                if (value.isLoading)
                  return Center(child: CircularProgressIndicator());
                if (value.error != null)
                  return Center(child: Text('Error: ${value.error}'));
                final list = value.filteredExercises;
                if (list.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Brak ćwiczeń',
                        style: TextStyle(fontSize: 18.0, color: Colors.white70),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    key: PageStorageKey('exercisesList'),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final cwiczenie = list[index];
                      return Card(
                        color: Color(0xFF424450),
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 6,
                        ),
                        child: ListTile(
                          title: Text(
                            cwiczenie.nazwa ?? 'Brak nazwy',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(
                            Icons.fitness_center,
                            color: Color(0xFFFFB800),
                          ),
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ExerciseDetailView(
                                        exercise: cwiczenie,
                                      ),
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
