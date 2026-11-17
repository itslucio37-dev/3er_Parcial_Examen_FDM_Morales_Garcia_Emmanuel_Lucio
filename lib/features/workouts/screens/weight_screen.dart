import 'package:flutter/material.dart';
import 'package:fit_track_pro/features/workouts/models/weight_model.dart';
import 'package:fit_track_pro/features/workouts/screens/add_weight_screen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  List<WeightModel> registros = [];

  Future<void> _navigateToAddWeight() async {
    final newWeight = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWeightScreen()),
    );

    if (newWeight != null && newWeight is WeightModel) {
      setState(() {
        registros.add(newWeight);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de peso'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: registros.isEmpty
          ? const Center(child: Text('No hay registros'))
          : ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.monitor_weight)),
                    title: Text(
                      registro.fecha,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${registro.pesoKilos} kg'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddWeight,
        child: const Icon(Icons.add),
      ),
    );
  }
}