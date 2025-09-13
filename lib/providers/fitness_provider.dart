import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../models/workout.dart';
import '../services/storage_service.dart';

/// Provider for managing fitness app state
class FitnessProvider extends ChangeNotifier {
  final StorageService _storageService;
  
  UserProfile? _userProfile;
  List<Workout> _workouts = [];
  bool _isLoading = false;
  String? _error;

  FitnessProvider(this._storageService);

  // Getters
  UserProfile? get userProfile => _userProfile;
  List<Workout> get workouts => List.unmodifiable(_workouts);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasProfile => _userProfile != null;

  // Computed properties
  int get totalWorkouts => _workouts.length;
  
  int get totalCaloriesBurned => _workouts.fold(
    0, 
    (sum, workout) => sum + workout.caloriesBurned,
  );
  
  Duration get totalWorkoutTime => _workouts.fold(
    Duration.zero,
    (sum, workout) => sum + workout.duration,
  );

  List<Workout> get recentWorkouts {
    final sortedWorkouts = List<Workout>.from(_workouts)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sortedWorkouts.take(5).toList();
  }

  Map<WorkoutType, int> get workoutsByType {
    final Map<WorkoutType, int> typeCount = {};
    for (final workout in _workouts) {
      typeCount[workout.type] = (typeCount[workout.type] ?? 0) + 1;
    }
    return typeCount;
  }

  /// Initialize the provider
  Future<void> initialize() async {
    await _executeWithLoading(() async {
      await _loadUserProfile();
      await _loadWorkouts();
    });
  }

  /// User Profile Methods
  Future<void> createUserProfile(UserProfile profile) async {
    await _executeWithLoading(() async {
      await _storageService.saveUserProfile(profile);
      _userProfile = profile;
    });
  }

  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    await _executeWithLoading(() async {
      await _storageService.saveUserProfile(updatedProfile);
      _userProfile = updatedProfile;
    });
  }

  Future<void> deleteUserProfile() async {
    await _executeWithLoading(() async {
      await _storageService.deleteUserProfile();
      _userProfile = null;
    });
  }

  /// Workout Methods
  Future<void> addWorkout(Workout workout) async {
    await _executeWithLoading(() async {
      await _storageService.addWorkout(workout);
      _workouts.add(workout);
      _sortWorkouts();
    });
  }

  Future<void> updateWorkout(Workout updatedWorkout) async {
    await _executeWithLoading(() async {
      await _storageService.updateWorkout(updatedWorkout);
      final index = _workouts.indexWhere((w) => w.id == updatedWorkout.id);
      if (index != -1) {
        _workouts[index] = updatedWorkout;
        _sortWorkouts();
      }
    });
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _executeWithLoading(() async {
      await _storageService.deleteWorkout(workoutId);
      _workouts.removeWhere((w) => w.id == workoutId);
    });
  }

  /// Get workouts for a specific date range
  List<Workout> getWorkoutsInDateRange(DateTime start, DateTime end) {
    return _workouts.where((workout) {
      return workout.date.isAfter(start.subtract(const Duration(days: 1))) &&
             workout.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get workouts for today
  List<Workout> getTodaysWorkouts() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getWorkoutsInDateRange(startOfDay, endOfDay);
  }

  /// Get workouts for this week
  List<Workout> getThisWeeksWorkouts() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return getWorkoutsInDateRange(startOfWeek, endOfWeek);
  }

  /// Get calories burned in date range
  int getCaloriesBurnedInDateRange(DateTime start, DateTime end) {
    return getWorkoutsInDateRange(start, end)
        .fold(0, (sum, workout) => sum + workout.caloriesBurned);
  }

  /// Clear all data
  Future<void> clearAllData() async {
    await _executeWithLoading(() async {
      await _storageService.clear();
      _userProfile = null;
      _workouts.clear();
    });
  }

  /// Private helper methods
  Future<void> _loadUserProfile() async {
    try {
      _userProfile = await _storageService.getUserProfile();
    } catch (e) {
      _setError('Failed to load user profile: $e');
    }
  }

  Future<void> _loadWorkouts() async {
    try {
      _workouts = await _storageService.getWorkouts();
      _sortWorkouts();
    } catch (e) {
      _setError('Failed to load workouts: $e');
    }
  }

  void _sortWorkouts() {
    _workouts.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _executeWithLoading(Future<void> Function() operation) async {
    _setLoading(true);
    _clearError();
    
    try {
      await operation();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  void _clearError() {
    _setError(null);
  }
}