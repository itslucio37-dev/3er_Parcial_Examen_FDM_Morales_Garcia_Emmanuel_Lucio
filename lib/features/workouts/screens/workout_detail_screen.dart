import 'package:flutter/material.dart';
import 'package:fit_track_pro/features/workouts/models/workout_model.dart';
import 'package:fit_track_pro/features/workouts/services/local_workout_service.dart';
import 'package:fit_track_pro/features/workouts/screens/edit_workout_screen.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutModel workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final LocalWorkoutService _dbService = LocalWorkoutService();
  late WorkoutModel _currentWorkout;

  @override
  void initState() {
    super.initState();
    _currentWorkout = widget.workout;
  }

  Future<void> _navigateToEdit() async {
    final updatedWorkout = await Navigator.push<WorkoutModel>(
      context,
      MaterialPageRoute(
        builder: (context) => EditWorkoutScreen(workout: _currentWorkout),
      ),
    );

    if (updatedWorkout != null) {
      await _dbService.updateWorkout(updatedWorkout);
      setState(() {
        _currentWorkout = updatedWorkout;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rutina actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Rutina'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.fitness_center),
                      ),
                      title: Text(
                        _currentWorkout.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Categoría: ${_currentWorkout.category}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Duración: ${_currentWorkout.durationMinutes} minutos',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _navigateToEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Editar Rutina', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver', style: TextStyle(fontSize: 18)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}