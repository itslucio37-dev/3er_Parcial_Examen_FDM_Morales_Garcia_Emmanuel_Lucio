class WorkoutModel{
  final int? localId;
  //final int? apidId;
  final String title;
  final String category;
  final int durationMinutes;

  WorkoutModel({
    this.localId,
    //this.apidId,
    required this.title,
    required this.category,
    required this.durationMinutes
  });

  Map<String, dynamic> toMap(){
    return {
      'id' : localId,
      //'apidId' : apidId,
      'title' : title,
      'category' : category,
      'duration_minutes' : durationMinutes // <-- Debe ser duration_minutes
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map){
    return WorkoutModel(
      localId: map['id'],
      //apidId: map['apidId'],
      title: map['title'],
      category: map['category'],
      durationMinutes: map['duration_minutes'] // <-- Debe ser duration_minutes
    );
  }
}