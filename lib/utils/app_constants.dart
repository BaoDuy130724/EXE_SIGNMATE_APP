class AppConstants {
  // Plan Types
  static const String planFree = 'free';
  static const String planBasic = 'basic';
  static const String planPro = 'pro';

  // Role Types
  static const String roleStudent = 'student';
  static const String roleTeacher = 'teacher';
  static const String roleCenterAdmin = 'center_admin';
  static const String roleSuperAdmin = 'super_admin';

  // Pricing
  static const int basicPriceMonthly = 49000; // VND
  static const int proPriceMonthly = 99000; // VND
  static const int b2bPricePerLearner = 39000; // VND
  static const int b2bMinSeats = 20;

  // Free plan limits
  static const int freeLessonsPerDay = 5;

  // Gamification
  static const int xpPerCorrectAnswer = 10;
  static const int xpPerLessonComplete = 50;
  static const int xpPerGameWin = 25;

  // Practice
  static const int practiceTimerSeconds = 30;

  // App info
  static const String appName = 'SignMate';
  static const String appTagline = 'Học ngôn ngữ ký hiệu cùng AI';
}
