import 'package:fit_track_pro/features/workouts/screens/add_workout_screen.dart';
import 'package:fit_track_pro/features/workouts/screens/workout_detail_screen.dart';
import 'package:fit_track_pro/features/workouts/screens/weight_screen.dart';
import 'package:flutter/material.dart';
import 'package:fit_track_pro/features/workouts/services/local_workout_service.dart';
import 'package:fit_track_pro/features/workouts/models/workout_model.dart';
import 'package:fit_track_pro/core/storage/local_storage_service.dart';
import 'package:fit_track_pro/features/auth/screens/login_screen.dart'; 

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final LocalWorkoutService _dbService = LocalWorkoutService();

  List<WorkoutModel> _workouts = [];
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async{
    setState((){
      _isLoading = true;
    });

    final workouts = await _dbService.getWorkouts();

    setState((){
      _workouts = workouts;
      _isLoading = false;
    });
  }

  void _logout() async{
    final storage = LocalStorageService();
    await storage.deleteToken();

    if(!mounted) return;
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }


/*  void _showAddWorkoutDialog(){
    final titleController = TextEditingController();
    final categoryController = TextEditingController();
    final durationMinutesController = TextEditingController();

    showDialog(context: context,
      builder: (context) =>
      AlertDialog(
        title: Text('Nueva rutina'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Categoria'),
            ),
            TextField(
              controller: durationMinutesController,
              decoration: InputDecoration(labelText: 'Duracion (minutos)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(onPressed: () async {

            if(titleController.text.isNotEmpty && durationMinutesController.text.isNotEmpty && categoryController.text.isEmpty){
              final newWorkout = WorkoutModel(
                title: titleController.text,
                category: categoryController.text,
                durationMinutes: int.parse(durationMinutesController.text));

                await _dbService.insertWorkout(newWorkout);

                if(mounted){
                  Navigator.pop(context);
                  _loadWorkouts();
                }
            }
          }, child: Text('Guardar')),
        ],
      ),
    );
  }
*/


  Future<void> _navigateToAddWorkout() async{
    final newWorkout = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
    );

    if(newWorkout != null && newWorkout is WorkoutModel){
      await _dbService.insertWorkout(newWorkout);

      _loadWorkouts();

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rutina creada exitosamente'),
          backgroundColor: Colors.green,)
        );
      }
    }

  }

  Future<void> _navigateToDetail(WorkoutModel workout) async {
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailScreen(workout: workout),
      ),
    );

    if (shouldRefresh == true || shouldRefresh == null) {
      _loadWorkouts();
    }
  }

  Future<void> _deleteWorkout(int id, String title) async{
    await _dbService.deleteWorkout(id);
    if(mounted){
      _loadWorkouts();
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rutina Eliminada: ${title}')));
    }
      
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis entrenamientos"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions:[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeightScreen()),
              );
            },
            icon: Icon(Icons.monitor_weight)
          ),
          IconButton(
          onPressed: ()
          {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Cerrar Sesion?'),
                content: Text('Tendras que volver a ingresar tus datos'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar')),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                      _logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text('Salir', style: TextStyle(color: Colors.white),)
                  ),
                ],
              ),
            );

          },
        icon: Icon(Icons.logout)
          )
        ]
      ),
      body: _isLoading
      ? Center(child: CircularProgressIndicator(),)
      : _workouts.isEmpty
        ? Center(child: Text("No tienes rutinas creadas"),)
        :ListView.builder(
          itemCount: _workouts.length,
          itemBuilder: (context, index){
            final workout = _workouts[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                onTap: () => _navigateToDetail(workout),
                leading: CircleAvatar(child: Icon(Icons.fitness_center)),
                title: Text(
                  workout.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  onPressed: () => _deleteWorkout(workout.localId!, workout.title),
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
                subtitle: Text(
                  '${workout.category}\n${workout.durationMinutes} min',
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddWorkout,
          child: Icon(Icons.add),
        ),
    );
  }
}