import 'package:flutter/material.dart';
import 'package:gym_tracker_app/models/user.dart';
import 'package:gym_tracker_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  late UserViewModel userVM;
  User? user;
  bool _isInit = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      userVM = Provider.of<UserViewModel>(context, listen: false);
      user = userVM.user;
      if (user != null) {
        nameController.text = user!.imie ?? '';
        surnameController.text = user!.nazwisko ?? '';
        ageController.text = user!.wiek != null ? user!.wiek.toString() : '';
        heightController.text = user!.wzrost != null ? user!.wzrost.toString() : '';
        weightController.text = userVM.latestWeight?.toString() ?? '';
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF31353C),
      appBar: AppBar(
        title: const Text("Edytuj profil"),
        centerTitle: true,
        backgroundColor: const Color(0xFF31353C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Imię
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Imię",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Nazwisko
              TextFormField(
                controller: surnameController,
                decoration: const InputDecoration(
                  labelText: "Nazwisko",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Wiek
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: "Wiek",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Wzrost
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(
                  labelText: "Wzrost (cm)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Waga
              TextFormField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: "Waga (kg)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              // Zapisz
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8B100),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (userVM.user == null) return;
                      final updatedUser = User(
                        id: userVM.user!.id,
                        imie: nameController.text,
                        nazwisko: surnameController.text,
                        wiek: int.tryParse(ageController.text) ?? 0,
                        wzrost: double.tryParse(heightController.text) ?? 0.0,
                      );

                      userVM.updateUser(updatedUser);
                      userVM.changeLatestWeight(double.tryParse(weightController.text) ?? 0.0);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Zapisano zmiany")),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text("Zapisz"),
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



