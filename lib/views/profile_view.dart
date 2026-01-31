import 'package:flutter/material.dart';
import 'package:gym_tracker_app/view_models/user_view_model.dart';
import 'package:gym_tracker_app/views/edit_profile_view.dart';
import 'package:gym_tracker_app/views/weight_chart_view.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<UserViewModel>(context);
    final user = userVM.user;

    return Scaffold(
      backgroundColor: Color(0xFF31353C),

      appBar: AppBar(
        backgroundColor: Color(0xFF31353C),
        elevation: 0,
        toolbarHeight: 30,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFFFB800)),
            onPressed: () async {
              await userVM.loadUser();
            },
          ),
        ],
      ),
      body:
          user != null
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    // Zdjęcie profilowe / avatar
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 60),
                      // backgroundImage: NetworkImage(user.profileImageUrl),
                    ),

                    const SizedBox(height: 16),

                    // Imię i nazwisko użytkownika
                    Text(
                      "${user.imie} ${user.nazwisko}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Twoje dane podstawowe",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 32),

                    // Sekcja informacji
                    Card(
                      color: Color(0xFF23272A),
                      child: ListTile(

                        // leading: const Icon(Icons.cake),
                        leading: const Icon(Icons.cake),
                        title: const Text("Wiek"),
                        subtitle: Text("${user.wiek} lat"),
                      ),
                    ),

                    Card(
                      color: Color(0xFF23272A),
                      child: ListTile(
                        leading: const Icon(Icons.height),
                        title: const Text("Wzrost"),
                        subtitle: Text("${user.wzrost} cm"),
                      ),
                    ),

                    Card(
                      color: const Color(0xFF23272A),
                      child: ListTile(
                        leading: const Icon(Icons.monitor_weight),
                        title: const Text("Waga"),
                        subtitle: Text(
                          userVM.latestWeight != null
                              ? "${userVM.latestWeight!.toStringAsFixed(1)} kg"
                              : 'Brak danych',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.show_chart, color: Color(0xFFFFB800)),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WeightChartView()),
                            );
                          },
                          tooltip: 'Pokaż wykres wagi',
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Przycisk edycji profilu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileView(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Edytuj profil"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF8B100),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // EKSPORT WSZYSTKUCH DANYCH JSON
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton.icon(
                    //     onPressed: () async {
                    //       try {
                    //         await ExportService.exportDatabaseToJsonAndShare();
                            
                    //       } catch (e) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(content: Text("Błąd eksportu: $e")),
                    //         );
                    //       }
                    //     },
                    //     icon: const Icon(Icons.download),
                    //     label: const Text("Eksportuj dane (JSON)"),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFF23272A),
                    //       foregroundColor: const Color(0xFFFFB800),
                    //       padding: const EdgeInsets.symmetric(vertical: 14),
                    //       textStyle: const TextStyle(fontSize: 16),
                    //     ),
                    //   ),
                    // ),

                    // const SizedBox(height: 12),

                  ],
                ),
              )
              : Text(
                'Brak danych użytkownika',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
    );
  }
}
