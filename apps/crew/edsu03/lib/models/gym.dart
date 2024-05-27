class GymRoutine {
  final String owner;
  final List<GymDay> days;

  GymRoutine({
    required this.owner,
    required this.days,
  });

  factory GymRoutine.fromFirestore(Map<String, dynamic> data, String documentId) {
    return GymRoutine(
      owner: data['owner'] ?? '',
      days: data['days'] ?? List.empty(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'owner': owner,
      'days': days,
    };
  }
}

class GymDay {
  final String name;
  final List<Exercise> exercises;

  GymDay(
    {
      required this.name,
      required this.exercises,
    }
  );
}

class Exercise {
  String name;
  int weight;
  int sets;
  int reps;

  Exercise(
    {
      required this.name,
      required this.weight,
      required this.sets,
      required this.reps,
    }
  );
  
}