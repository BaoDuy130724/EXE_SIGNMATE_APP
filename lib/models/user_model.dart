class UserModel {
  final String id;
  final String name;
  final String email;
  final String userRole;
  final String plan;
  final int streak;
  final int totalXp;
  final int level;
  final int lessonsCompleted;
  final int practiceAccuracy;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userRole,
    required this.plan,
    required this.streak,
    required this.totalXp,
    required this.level,
    required this.lessonsCompleted,
    required this.practiceAccuracy,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      userRole: json['role'] ?? 'student',
      plan: json['plan'] ?? 'free',
      streak: json['streak'] ?? 0,
      totalXp: json['totalXp'] ?? 0,
      level: json['level'] ?? 1,
      lessonsCompleted: json['lessonsCompleted'] ?? 0,
      practiceAccuracy: json['practiceAccuracy'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': userRole,
      'plan': plan,
      'streak': streak,
      'totalXp': totalXp,
      'level': level,
      'lessonsCompleted': lessonsCompleted,
      'practiceAccuracy': practiceAccuracy,
    };
  }
}
