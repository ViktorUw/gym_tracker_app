import 'package:flutter/material.dart';
import 'package:gym_tracker_app/mainPage.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/seed_initial_data.dart';
import 'package:gym_tracker_app/view_models/exercise_view_model.dart';
import 'package:gym_tracker_app/view_models/training_plans_view_model.dart';
import 'package:gym_tracker_app/view_models/user_view_model.dart';
import 'package:gym_tracker_app/views/registration_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseServices.instance.getDatabase();
  await seedInitialData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => TrainingPlansViewModel()),
        ChangeNotifierProvider(create: (_) => CwiczeniaViewModel()),
      ],
      child: GymTrackerApp(),
    ),
  );
}

class GymTrackerApp extends StatelessWidget {

  GymTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: UserViewModel().hasUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data == true) {
            return MainPage();
          } else {
          
            return RegistrationView();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      title: 'Gym Tracker',
      theme: ThemeData.dark().copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Color(0xFF23272A),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFF8B100)),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}

