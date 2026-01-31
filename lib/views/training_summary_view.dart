import 'package:flutter/material.dart';


class TrainingSummaryView extends StatelessWidget {  
  final String trainingName;
  final String trainingDate;
  final String duration;
  final double totalVolume;

  const TrainingSummaryView({
    Key? key,
    required this.trainingName,
    required this.trainingDate,
    required this.duration,
    required this.totalVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF31353C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF31353C),
        elevation: 0,
        title: const Text('Podsumowanie treningu'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 80,
                color: Color(0xFF4CAF50),
              ),
              const SizedBox(height: 24),
              Text(
                'Gratulacje!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFF23272A),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSummaryRow('Trening:', trainingName),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Czas:', duration),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        'Całkowita objętość:',
                        '${totalVolume.toStringAsFixed(1)} kg',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      () => Navigator.of(
                        context,
                      ).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Powrót do historii treningów',
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

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
