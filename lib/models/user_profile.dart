import 'package:equatable/equatable.dart';

/// User profile data model
class UserProfile extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime? dateOfBirth;
  final double? weight;
  final double? height;
  final String? gender;
  final String? fitnessGoal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.gender,
    this.fitnessGoal,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate BMI if height and weight are available
  double? get bmi {
    if (height == null || weight == null || height! <= 0) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return 'Unknown';
    
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  /// Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month || 
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Copy with method for immutable updates
  UserProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? dateOfBirth,
    double? weight,
    double? height,
    String? gender,
    String? fitnessGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'weight': weight,
      'height': height,
      'gender': gender,
      'fitnessGoal': fitnessGoal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ///Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      gender: json['gender'] as String?,
      fitnessGoal: json['fitnessGoal'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        dateOfBirth,
        weight,
        height,
        gender,
        fitnessGoal,
        createdAt,
        updatedAt,
      ];
}