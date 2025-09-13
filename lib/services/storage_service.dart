import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/workout.dart';
import '../common/app_constants.dart';

/// Service for handling local data storage
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// User Profile Storage
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final jsonString = jsonEncode(profile.toJson());
      await _prefs!.setString(AppConstants.userProfileKey, jsonString);
    } catch (e) {
      throw StorageException('Failed to save user profile: $e');
    }
  }

  Future<UserProfile?> getUserProfile() async {
    try {
      final jsonString = _prefs!.getString(AppConstants.userProfileKey);
      if (jsonString == null) return null;
      
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (e) {
      throw StorageException('Failed to load user profile: $e');
    }
  }

  Future<void> deleteUserProfile() async {
    try {
      await _prefs!.remove(AppConstants.userProfileKey);
    } catch (e) {
      throw StorageException('Failed to delete user profile: $e');
    }
  }

  /// Workout Data Storage
  Future<void> saveWorkouts(List<Workout> workouts) async {
    try {
      final jsonList = workouts.map((w) => w.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs!.setString(AppConstants.workoutDataKey, jsonString);
    } catch (e) {
      throw StorageException('Failed to save workouts: $e');
    }
  }

  Future<List<Workout>> getWorkouts() async {
    try {
      final jsonString = _prefs!.getString(AppConstants.workoutDataKey);
      if (jsonString == null) return [];
      
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => Workout.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException('Failed to load workouts: $e');
    }
  }

  Future<void> addWorkout(Workout workout) async {
    try {
      final workouts = await getWorkouts();
      workouts.add(workout);
      await saveWorkouts(workouts);
    } catch (e) {
      throw StorageException('Failed to add workout: $e');
    }
  }

  Future<void> updateWorkout(Workout updatedWorkout) async {
    try {
      final workouts = await getWorkouts();
      final index = workouts.indexWhere((w) => w.id == updatedWorkout.id);
      
      if (index != -1) {
        workouts[index] = updatedWorkout;
        await saveWorkouts(workouts);
      } else {
        throw StorageException('Workout not found');
      }
    } catch (e) {
      throw StorageException('Failed to update workout: $e');
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      final workouts = await getWorkouts();
      workouts.removeWhere((w) => w.id == workoutId);
      await saveWorkouts(workouts);
    } catch (e) {
      throw StorageException('Failed to delete workout: $e');
    }
  }

  /// Generic storage methods
  Future<void> setString(String key, String value) async {
    try {
      await _prefs!.setString(key, value);
    } catch (e) {
      throw StorageException('Failed to save string: $e');
    }
  }

  String? getString(String key) {
    try {
      return _prefs!.getString(key);
    } catch (e) {
      throw StorageException('Failed to get string: $e');
    }
  }

  Future<void> setBool(String key, bool value) async {
    try {
      await _prefs!.setBool(key, value);
    } catch (e) {
      throw StorageException('Failed to save boolean: $e');
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs!.getBool(key);
    } catch (e) {
      throw StorageException('Failed to get boolean: $e');
    }
  }

  Future<void> setInt(String key, int value) async {
    try {
      await _prefs!.setInt(key, value);
    } catch (e) {
      throw StorageException('Failed to save integer: $e');
    }
  }

  int? getInt(String key) {
    try {
      return _prefs!.getInt(key);
    } catch (e) {
      throw StorageException('Failed to get integer: $e');
    }
  }

  Future<void> remove(String key) async {
    try {
      await _prefs!.remove(key);
    } catch (e) {
      throw StorageException('Failed to remove key: $e');
    }
  }

  Future<void> clear() async {
    try {
      await _prefs!.clear();
    } catch (e) {
      throw StorageException('Failed to clear storage: $e');
    }
  }
}

/// Custom exception for storage operations
class StorageException implements Exception {
  final String message;
  
  const StorageException(this.message);
  
  @override
  String toString() => 'StorageException: $message';
}