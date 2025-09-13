/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Fitness Tracker';
  static const String appVersion = '1.0.0';
  
  // API Endpoints (for future backend integration)
  static const String baseUrl = 'https://api.fitness-tracker.com';
  static const String apiVersion = 'v1';
  
  // Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String workoutDataKey = 'workout_data';
  static const String mealDataKey = 'meal_data';
  static const String sleepDataKey = 'sleep_data';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Chart Constants
  static const int maxChartDataPoints = 30;
  static const double chartAnimationDuration = 3.0;
}