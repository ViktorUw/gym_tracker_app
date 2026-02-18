import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/exercises.dart';

class ExerciseDetailView extends StatefulWidget {
  final Exercises exercise;

  const ExerciseDetailView({Key? key, required this.exercise})
    : super(key: key);

  @override
  _ExerciseDetailViewState createState() => _ExerciseDetailViewState();
}

class _ExerciseDetailViewState extends State<ExerciseDetailView> {

  late VideoPlayerController _controller;
  bool _isInitialized = false;
  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.asset(
            'assets/videos/${widget.exercise.gifUrl}.mp4',
          )
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            setState(() {
              _isInitialized = true;
            });
            _controller.play();
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31353C),
      appBar: AppBar(
        backgroundColor: Color(0xFF31353C),
        elevation: 0,
        title: Text(widget.exercise.exerciseName ?? 'Cwiczenie' ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- WIDEO ---
           Container(
              height: 240,
              width: double.infinity,
              color: Color(0xFF23252B),
              child:
                  _isInitialized
                      ? ClipRect(
                        child: FittedBox(
                          fit:
                              BoxFit
                                  .cover, 
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      )
                      : Center(child: CircularProgressIndicator()),
            ),

            // --- NAZWA ĆWICZENIA ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Text(
                widget.exercise.exerciseName ?? 'Nazwa ćwiczenia',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // --- GRUPA MIESNIOWA ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                'grupa mięsniowa: ${widget.exercise.muscleGroup ?? 'Grupa mięśniowa'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
            // --- OPIS ĆWICZENIA ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              child: Text(
                widget.exercise.exerciseDescription ?? 'Opis.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
