import 'package:equatable/equatable.dart';

/// Workout data model
class Workout extends Equatable {
  final String id;
  final String name;
  final WorkoutType type;
  final Duration duration;
  final int caloriesBurned;
  final DateTime date;
  final String? notes;
  final List<Exercise> exercises;

  const Workout({
    required this.id,
    required this.name,
    required this.type,
    required this.duration,
    required this.caloriesBurned,
    required this.date,
    this.notes,
    this.exercises = const [],
  });

  /// Get formatted duration string
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Calculate calories per minute
  double get caloriesPerMinute {
    final totalMinutes = duration.inMinutes;
    return totalMinutes > 0 ? caloriesBurned / totalMinutes : 0;
  }

  Workout copyWith({
    String? id,
    String? name,
    WorkoutType? type,
    Duration? duration,
    int? caloriesBurned,
    DateTime? date,
    String? notes,
    List<Exercise>? exercises,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'duration': duration.inMinutes,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
      'notes': notes,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      type: WorkoutType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WorkoutType.other,
      ),
      duration: Duration(minutes: json['duration'] as int),
      caloriesBurned: json['caloriesBurned'] as int,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        duration,
        caloriesBurned,
        date,
        notes,
        exercises,
      ];
}

/// Exercise within a workout
class Exercise extends Equatable {
  final String name;
  final int sets;
  final int reps;
  final double? weight;
  final Duration? restTime;

  const Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.weight,
    this.restTime,
  });

  Exercise copyWith({
    String? name,
    int? sets,
    int? reps,
    double? weight,
    Duration? restTime,
  }) {
    return Exercise(
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      restTime: restTime ?? this.restTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'restTime': restTime?.inSeconds,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      weight: json['weight']?.toDouble(),
      restTime: json['restTime'] != null
          ? Duration(seconds: json['restTime'] as int)
          : null,
    );
  }

  @override
  List<Object?> get props => [name, sets, reps, weight, restTime];
}

/// Workout types enum
enum WorkoutType {
  cardio,
  strength,
  flexibility,
  sports,
  yoga,
  pilates,
  crossfit,
  running,
  cycling,
  swimming,
  other;

  String get displayName {
    switch (this) {
      case WorkoutType.cardio:
        return 'Cardio';
      case WorkoutType.strength:
        return 'Strength Training';
      case WorkoutType.flexibility:
        return 'Flexibility';
      case WorkoutType.sports:
        return 'Sports';
      case WorkoutType.yoga:
        return 'Yoga';
      case WorkoutType.pilates:
        return 'Pilates';
      case WorkoutType.crossfit:
        return 'CrossFit';
      case WorkoutType.running:
        return 'Running';
      case WorkoutType.cycling:
        return 'Cycling';
      case WorkoutType.swimming:
        return 'Swimming';
      case WorkoutType.other:
        return 'Other';
    }
  }
}