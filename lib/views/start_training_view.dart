import 'package:flutter/material.dart';
import 'package:gym_tracker_app/views/training_session_view.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker_app/view_models/training_plans_view_model.dart';
import 'package:gym_tracker_app/view_models/user_view_model.dart';
import 'package:gym_tracker_app/models/training_plans.dart';

class StartTrainingView extends StatefulWidget {
  const StartTrainingView({super.key});

  @override
  State<StartTrainingView> createState() => _StartTrainingViewState();
}

class _StartTrainingViewState extends State<StartTrainingView> {
  final TextEditingController _trainingNameCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  TrainingPlans? _selectedPlan;
  bool _loadingPlans = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plansVm = Provider.of<TrainingPlansViewModel>(context, listen: false);
      plansVm.loadPlans().whenComplete(() {
        if (!mounted) return;
        setState(() => _loadingPlans = false);
      });

      final userVm = Provider.of<UserViewModel>(context, listen: false);
      if (userVm.latestWeight != null) {
        _weightCtrl.text = userVm.latestWeight!.toStringAsFixed(1);
      }
    });
  }

  @override
  void dispose() {
    _trainingNameCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Trening poranny';
    } else if (hour < 18) {
      return 'Trening popołudniowy';
    } else {
      return 'Trening wieczorny';
    }
  }

  void _startTraining() {
    var name = _selectedPlan?.plan_name ?? 'Trening';
    final weight = double.tryParse(_weightCtrl.text);


    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wpisz prawidłową wagę')));
      return;
    }

    if (_selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wybierz plan treningu')));
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => TrainingSessionView(
        trainingName: name,
        startingWeight: weight,
        plan: _selectedPlan!,
      ),
    ));

  }

  @override
  Widget build(BuildContext context) {
    final plansVm = Provider.of<TrainingPlansViewModel>(context);
    final plans = plansVm.plans;

    return Scaffold(
      backgroundColor: const Color(0xFF31353C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF31353C),
        elevation: 0,
        title: Text(_getGreeting()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _weightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Twoja waga (kg)',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2E3135),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              _loadingPlans
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<TrainingPlans>(
                      value: _selectedPlan,
                      items: plans.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p.plan_name ?? 'Bez nazwy'),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _selectedPlan = v),
                      decoration: InputDecoration(
                        labelText: 'Wybierz plan treningu',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF2E3135),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      dropdownColor: const Color(0xFF2E3135),
                      style: const TextStyle(color: Colors.white),
                    ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startTraining,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Rozpocznij trening',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}