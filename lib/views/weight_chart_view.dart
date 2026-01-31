import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_tracker_app/services/database_services.dart';
import 'package:gym_tracker_app/services/db_fields.dart';
import 'package:gym_tracker_app/services/export_service.dart';
import 'package:provider/provider.dart';

import 'package:gym_tracker_app/models/weight_measurment.dart';
import 'package:gym_tracker_app/repositories/weight_measurment_repository.dart';
import 'package:gym_tracker_app/view_models/user_view_model.dart';
import 'package:sqflite/sql.dart';

class WeightChartView extends StatefulWidget {
  const WeightChartView({super.key});

  @override
  State<WeightChartView> createState() => _WeightChartViewState();
}

class _WeightChartViewState extends State<WeightChartView> {
  final WeightMeasurmentRepository _repo = WeightMeasurmentRepository();

  bool _loading = true;
  List<WeightMeasurment> _records = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final userVm = context.read<UserViewModel>();
    final user = userVm.user;

    if (user?.id == null) {
      setState(() {
        _records = [];
        _loading = false;
      });
      return;
    }

    setState(() => _loading = true);

    final list = await _repo.getAllForUser(user!.id!);

    list.sort((a, b) {
      final aId = a.id ?? 0;
      final bId = b.id ?? 0;
      return aId.compareTo(bId);
    });

    setState(() {
      _records = list;
      _loading = false;
    });
  }

  Future<void> _deleteRecord(WeightMeasurment record) async {
    final id = record.id;
    if (id == null) return;

    await _repo.deleteMassRecord(id);
    await _refresh();
  }

  Future<void> _showAddMassDialog({
    required BuildContext context,
    required int userId,
    required VoidCallback onSavedRefresh,
  }) async {
    String input = '';

    final double? mass = await showDialog<double?>(
      context: context,
      barrierDismissible: true,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Dodaj wagę"),
            content: TextField(
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: "Waga (kg)"),
              onChanged: (v) => input = v,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text("Anuluj"),
              ),
              ElevatedButton(
                onPressed: () {
                  final value = input.trim().replaceAll(',', '.');
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Wpisz poprawną wagę")),
                    );
                    return;
                  }
                  Navigator.pop(ctx, number);
                },
                child: const Text("Zapisz"),
              ),
            ],
          ),
    );

    if (mass == null) return;

    final now = DateTime.now();
    final String formattedDate =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final db = await DatabaseServices.instance.database;
    await db.insert(DbFields.tableMass, {
      DbFields.massUserId: userId,
      DbFields.massDate: formattedDate,
      DbFields.massValue: mass,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    onSavedRefresh();
  }

  double _minY() {
    if (_records.isEmpty) return 0;
    final min = _records
        .map((e) => e.wartosc)
        .reduce((a, b) => a! < b! ? a : b);
    return (min! - 5).floorToDouble();
  }

  double _maxY() {
    if (_records.isEmpty) return 100;
    final max = _records
        .map((e) => e.wartosc)
        .reduce((a, b) => a! > b! ? a : b);
    return (max! + 5).ceilToDouble();
  }

  List<FlSpot> _spots() {
    return List.generate(_records.length, (i) {
      return FlSpot(i.toDouble(), _records[i].wartosc!);
    });
  }

  String _bottomTitle(int value) {
    if (_records.isEmpty) return '';
    if (value < 0 || value >= _records.length) return '';

    final date = _records[value].data;
    return date!.length >= 10 ? date.substring(5, 10) : date;
  }

  Widget _chart() {
    return LineChart(
      LineChartData(
        backgroundColor: Color(0xFF23272A),
        minY: _minY(),
        maxY: _maxY(),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final text = _bottomTitle(value.round());
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8,
                  child: Text(text, style: const TextStyle(fontSize: 10)),
                );
              },
              reservedSize: 28,
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _spots(),
            isCurved: true,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((s) {
                return LineTooltipItem(
                  '${s.y.toStringAsFixed(1)} kg',
                  const TextStyle(fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _recordsList() {
    final list = [..._records];
    list.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));

    if (list.isEmpty) {
      return const Center(child: Text('Niema zapisów wagi.'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final r = list[i];

        return ListTile(
          dense: true,
          title: Text('${r.wartosc!.toStringAsFixed(1)} kg'),
          subtitle: Text(r.data!),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Color.fromARGB(255, 255, 27, 2),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Usunąć zapis?'),
                      content: Text(
                        'Data: ${r.data}\nWaga: ${r.wartosc!.toStringAsFixed(1)} kg',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Anuluj'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Usuń'),
                        ),
                      ],
                    ),
              );

              if (ok == true) {
                await _deleteRecord(r);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF31353C),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box),
              color: const Color(0xFFFFB800),
              onPressed: () async {
                await _showAddMassDialog(
                  context: context,
                  userId: 1,
                  onSavedRefresh: _refresh,
                );
              },
              tooltip: 'Dodaj nową wagę',
            ),
            IconButton(
              icon: const Icon(Icons.download),
              color: const Color(0xFFFFB800),
              onPressed: () async {
                await ExportService.exportMassToCsvAndShare();
              },
              tooltip: 'Eksportuj dane wagi (CSV)',
            ),
          ],
          backgroundColor: Color(0xFF31353C),
          title: const Text('Wykres wagi'),
        ),
        body:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                  child: Container(
                    color: const Color(0xFF31353C),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        16 + MediaQuery.of(context).padding.bottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 260, child: _chart()),
                          const SizedBox(height: 16),
                  
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF23272A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Historia wagi',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  _recordsList(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
