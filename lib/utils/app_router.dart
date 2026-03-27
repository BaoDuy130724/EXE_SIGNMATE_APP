import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/register_otp_screen.dart';
import '../screens/auth/register_step2_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/change_password_screen.dart';
import '../screens/auth/quiz_screen.dart';
import '../screens/auth/complete_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/home_new_screen.dart';
import '../screens/lesson/lesson_screen.dart';
import '../screens/lesson/lesson_detail_screen.dart';
import '../screens/practice/practice_screen.dart';
import '../screens/practice/practice_camera_screen.dart';
import '../screens/practice/feedback_screen.dart';
import '../screens/practice/result_correct_screen.dart';
import '../screens/practice/result_wrong_screen.dart';
import '../screens/practice/result_summary_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/premium/premium_screen.dart';
import '../screens/premium/premium_payment_screen.dart';
import '../screens/premium/contact_form_screen.dart';
import '../screens/game/game_screen.dart';
import '../screens/admin/admin_login_screen.dart';
import '../screens/admin/admin_home_screen.dart';
import '../screens/admin/admin_reports_screen.dart';
import '../screens/teacher/teacher_login_screen.dart';
import '../screens/teacher/teacher_home_screen.dart';
import '../screens/teacher/teacher_class_screen.dart';
import '../screens/teacher/teacher_students_screen.dart';
import '../screens/teacher/teacher_lessons_screen.dart';
import '../screens/teacher/teacher_feedback_screen.dart';
import '../screens/center/center_home_screen.dart';
import '../screens/center/center_classes_screen.dart';
import '../screens/center/center_class_detail_screen.dart';
import '../screens/center/center_students_screen.dart';
import '../screens/center/center_reports_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Auth
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: '/register-otp',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return RegisterOtpScreen(
            name: extras['name'] ?? '',
            email: extras['email'] ?? '',
            password: extras['password'] ?? '',
          );
        },
      ),
      GoRoute(path: '/register-step2', builder: (_, __) => const RegisterStep2Screen()),
      GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/change-password', builder: (_, __) => const ChangePasswordScreen()),
      GoRoute(path: '/quiz', builder: (_, __) => const QuizScreen()),
      GoRoute(path: '/complete', builder: (_, __) => const CompleteScreen()),

      // Main App
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/home-new', builder: (_, __) => const HomeNewScreen()),

      // Lessons
      GoRoute(path: '/lesson', builder: (_, __) => const LessonScreen()),
      GoRoute(path: '/lesson-detail', builder: (_, __) => const LessonDetailScreen()),

      // Practice & Feedback
      GoRoute(path: '/practice', builder: (_, __) => const PracticeScreen()),
      GoRoute(path: '/practice-camera', builder: (_, __) => const PracticeCameraScreen()),
      GoRoute(path: '/feedback', builder: (_, __) => const FeedbackScreen()),
      GoRoute(path: '/result-correct', builder: (_, __) => const ResultCorrectScreen()),
      GoRoute(path: '/result-wrong', builder: (_, __) => const ResultWrongScreen()),
      GoRoute(path: '/result-summary', builder: (_, __) => const ResultSummaryScreen()),

      // Game
      GoRoute(path: '/game', builder: (_, __) => const GameScreen()),

      // Profile & Premium
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/premium', builder: (_, __) => const PremiumScreen()),
      GoRoute(path: '/premium-payment', builder: (_, __) => const PremiumPaymentScreen()),
      GoRoute(path: '/contact-form', builder: (_, __) => const ContactFormScreen()),

      // Admin
      GoRoute(path: '/admin-login', builder: (_, __) => const AdminLoginScreen()),
      GoRoute(path: '/admin-home', builder: (_, __) => const AdminHomeScreen()),
      GoRoute(path: '/admin-reports', builder: (_, __) => const AdminReportsScreen()),

      // Teacher
      GoRoute(path: '/teacher-login', builder: (_, __) => const TeacherLoginScreen()),
      GoRoute(path: '/teacher-home', builder: (_, __) => const TeacherHomeScreen()),
      GoRoute(path: '/teacher-class', builder: (_, __) => const TeacherClassScreen()),
      GoRoute(path: '/teacher-students', builder: (_, __) => const TeacherStudentsScreen()),
      GoRoute(path: '/teacher-lessons', builder: (_, __) => const TeacherLessonsScreen()),
      GoRoute(path: '/teacher-feedback', builder: (_, __) => const TeacherFeedbackScreen()),

      // Center
      GoRoute(path: '/center-home', builder: (_, __) => const CenterHomeScreen()),
      GoRoute(path: '/center-classes', builder: (_, __) => const CenterClassesScreen()),
      GoRoute(path: '/center-class-detail', builder: (_, __) => const CenterClassDetailScreen()),
      GoRoute(path: '/center-students', builder: (_, __) => const CenterStudentsScreen()),
      GoRoute(path: '/center-reports', builder: (_, __) => const CenterReportsScreen()),
    ],
  );
}
