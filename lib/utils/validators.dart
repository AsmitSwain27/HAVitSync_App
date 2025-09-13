/// Utility class for form validation
class Validators {
  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }

  /// Weight validation (in kg)
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    
    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }
    
    if (weight > 1000) {
      return 'Please enter a realistic weight';
    }
    
    return null;
  }

  /// Height validation (in cm)
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Height is required';
    }
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid number';
    }
    
    if (height <= 0) {
      return 'Height must be greater than 0';
    }
    
    if (height < 50 || height > 300) {
      return 'Please enter a realistic height (50-300 cm)';
    }
    
    return null;
  }

  /// Age validation
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid number';
    }
    
    if (age < 13) {
      return 'Age must be at least 13';
    }
    
    if (age > 120) {
      return 'Please enter a realistic age';
    }
    
    return null;
  }

  /// Workout name validation
  static String? validateWorkoutName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Workout name is required';
    }
    
    if (value.length < 2) {
      return 'Workout name must be at least 2 characters long';
    }
    
    if (value.length > 100) {
      return 'Workout name must be less than 100 characters';
    }
    
    return null;
  }

  /// Duration validation (in minutes)
  static String? validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Duration is required';
    }
    
    final duration = int.tryParse(value);
    if (duration == null) {
      return 'Please enter a valid number';
    }
    
    if (duration <= 0) {
      return 'Duration must be greater than 0';
    }
    
    if (duration > 1440) { // 24 hours
      return 'Duration cannot exceed 24 hours';
    }
    
    return null;
  }

  /// Calories validation
  static String? validateCalories(String? value) {
    if (value == null || value.isEmpty) {
      return 'Calories is required';
    }
    
    final calories = int.tryParse(value);
    if (calories == null) {
      return 'Please enter a valid number';
    }
    
    if (calories < 0) {
      return 'Calories cannot be negative';
    }
    
    if (calories > 10000) {
      return 'Please enter a realistic calorie amount';
    }
    
    return null;
  }

  /// Exercise sets validation
  static String? validateSets(String? value) {
    if (value == null || value.isEmpty) {
      return 'Sets is required';
    }
    
    final sets = int.tryParse(value);
    if (sets == null) {
      return 'Please enter a valid number';
    }
    
    if (sets <= 0) {
      return 'Sets must be greater than 0';
    }
    
    if (sets > 100) {
      return 'Sets cannot exceed 100';
    }
    
    return null;
  }

  /// Exercise reps validation
  static String? validateReps(String? value) {
    if (value == null || value.isEmpty) {
      return 'Reps is required';
    }
    
    final reps = int.tryParse(value);
    if (reps == null) {
      return 'Please enter a valid number';
    }
    
    if (reps <= 0) {
      return 'Reps must be greater than 0';
    }
    
    if (reps > 1000) {
      return 'Reps cannot exceed 1000';
    }
    
    return null;
  }

  /// Exercise weight validation (in kg)
  static String? validateExerciseWeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Weight is optional for exercises
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    
    if (weight < 0) {
      return 'Weight cannot be negative';
    }
    
    if (weight > 1000) {
      return 'Please enter a realistic weight';
    }
    
    return null;
  }

  /// Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Generic number validation
  static String? validateNumber(String? value, String fieldName, {
    double? min,
    double? max,
    bool allowDecimals = true,
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    final number = allowDecimals 
        ? double.tryParse(value)
        : int.tryParse(value)?.toDouble();
    
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }
    
    if (max != null && number > max) {
      return '$fieldName cannot exceed $max';
    }
    
    return null;
  }

  /// Date validation
  static String? validateDate(DateTime? value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    
    final now = DateTime.now();
    if (value.isAfter(now)) {
      return '$fieldName cannot be in the future';
    }
    
    return null;
  }

  /// Date of birth validation
  static String? validateDateOfBirth(DateTime? value) {
    if (value == null) {
      return 'Date of birth is required';
    }
    
    final now = DateTime.now();
    if (value.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }
    
    final age = now.year - value.year;
    if (age < 13) {
      return 'You must be at least 13 years old';
    }
    
    if (age > 120) {
      return 'Please enter a valid date of birth';
    }
    
    return null;
  }
}