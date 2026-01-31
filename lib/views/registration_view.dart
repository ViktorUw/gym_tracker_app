import 'package:flutter/material.dart';
import 'package:gym_tracker_app/mainPage.dart';
import 'package:gym_tracker_app/models/weight_measurment.dart';
import 'package:gym_tracker_app/repositories/weight_measurment_repository.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker_app/models/user.dart';
import 'package:gym_tracker_app/view_models/user_view_model.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  DateTime dateOnlyNow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final userVM = Provider.of<UserViewModel>(context, listen: false);
      final now = DateTime.now();
      final String formattedDate =
          "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      await WeightMeasurmentRepository().insertMassRecord(
        WeightMeasurment(
          userId: 1,
          data: formattedDate,
          wartosc: double.parse(_weightController.text),
        ),
      );

      User newUser = User(
        id: 1,
        imie: _nameController.text,
        nazwisko: _surnameController.text,
        wiek: int.parse(_ageController.text),
        wzrost: double.parse(_heightController.text),
      );

      await userVM.addUser(newUser);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Rejestracja"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF1E1E1E),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Witamy!",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Wprowadź swoje dane, aby rozpocząć korzystanie z aplikacji.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.3,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      _darkInput(
                        controller: _nameController,
                        label: "Imię",
                        hint: "Wprowadź imię",
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 14),
                      _darkInput(
                        controller: _surnameController,
                        label: "Nazwisko",
                        hint: "Wprowadź nazwisko",
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 14),
                      _darkInput(
                        controller: _ageController,
                        label: "Wiek",
                        hint: "Wprowadź wiek",
                        icon: Icons.cake_outlined,
                        isNumber: true,
                      ),
                      const SizedBox(height: 14),
                      _darkInput(
                        controller: _heightController,
                        label: "Wzrost",
                        hint: "Wzrost (cm)",
                        icon: Icons.height,
                        isNumber: true,
                      ),
                      const SizedBox(height: 14),
                      _darkInput(
                        controller: _weightController,
                        label: "Waga",
                        hint: "Waga (kg)",
                        icon: Icons.monitor_weight_outlined,
                        isNumber: true,
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8B100),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: _registerUser,
                          child: const Text("Zarejestruj się"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _darkInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? "Pole wymagane" : null,
    );
  }
}
