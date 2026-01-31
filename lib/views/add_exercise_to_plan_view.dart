import 'package:flutter/material.dart';
import 'package:gym_tracker_app/view_models/cwiczenia_view_model.dart';
import 'package:provider/provider.dart';

class AddExerciseToPlanView extends StatefulWidget {
  final int planId;
  const AddExerciseToPlanView({super.key, required this.planId});

  @override
  State<AddExerciseToPlanView> createState() => _AddExerciseToPlanViewState();
}

class _AddExerciseToPlanViewState extends State<AddExerciseToPlanView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExercisesViewModel>(context, listen: false).loadExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31353C),
      appBar: AppBar(
        title: Text("Dodaj ćwiczenie"),
        backgroundColor: Color(0xFF31353C),
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
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Consumer<CwiczeniaViewModel>(
                builder: (context, vm, _) {
                  final filtered =
                      vm.cwiczenia.where((e) {
                        final matchSearch = e.nazwa!.toLowerCase().contains(
                          vm.searchQuery.toLowerCase(),
                        );
                        final matchGroup =
                            vm.selectedGroup == null ||
                            e.grupaMiesniowa == vm.selectedGroup;
                        return matchSearch && matchGroup;
                      }).toList();

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final ex = filtered[i];

                      return Card(
                        color: Color(0xFF23272A),
                        child: ListTile(
                          title: Text(
                            ex.nazwa!,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            ex.grupaMiesniowa ?? "",
                            style: TextStyle(color: Colors.white54),
                          ),
                          trailing: Icon(Icons.add, color: Colors.yellow),
                          onTap: () async {
                            await vm.addExerciseToPlan(widget.planId, ex.id!);
                            vm.loadExercisesForPlan(widget.planId);
                            Navigator.pop(context);
                          }
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
