import 'package:flutter/material.dart';
import 'package:gym_tracker_app/view_models/training_plans_view_model.dart';
import 'package:gym_tracker_app/views/create_plan_view.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker_app/views/each_plan_view.dart';

class TrainingPlanView extends StatefulWidget {
  @override
  _TrainingPlanViewState createState() => _TrainingPlanViewState();
}

class _TrainingPlanViewState extends State<TrainingPlanView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final vm = Provider.of<TrainingPlansViewModel>(
          context,
          listen: false,
        );
        vm.loadPlans();
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
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePlanView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFB800),
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),

              child: Text("Stworz wlasny plan treningowy"),
            ),
            SizedBox(height: 24),
            Consumer<TrainingPlansViewModel>(
              builder: (context, value, child) {
                if (value.isLoading)
                  return Center(child: CircularProgressIndicator());
                if (value.error != null)
                  return Center(child: Text('Error:  ${value.error}'));
                if (value.plans.isEmpty) {
                  return Center(
                    child: Text(
                      'Brak planów treningowych',
                      style: TextStyle(fontSize: 18.0, color: Colors.white70),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: value.plans.length,
                    itemBuilder: (context, index) {
                      final plan = value.plans[index];
                      return Card(
                        color: Color(0xFF424450),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            plan.plan_name ?? "Plan bez nazwy",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle:
                              plan.planDescription != null &&
                                      plan.planDescription!.isNotEmpty
                                  ? Text(
                                    plan.planDescription!,
                                    style: TextStyle(color: Colors.white),
                                  )
                                  : null,
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFFFB800),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EachPlanView(plan: plan),
                              ),
                            );
                          },
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
