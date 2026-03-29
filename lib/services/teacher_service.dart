import 'api_client.dart';

class TeacherService {
  final ApiClient _apiClient = ApiClient();

  /// Fetch dashboard metrics (total classes, total students)
  Future<Map<String, dynamic>> getTeacherDashboard() async {
    final response = await _apiClient.get('/teacher/dashboard');
    return response as Map<String, dynamic>;
  }

  /// Fetch teacher's classes
  Future<List<Map<String, dynamic>>> getTeacherClasses() async {
    final response = await _apiClient.get('/teacher/classes');
    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Fetch all students across teacher's classes
  Future<List<Map<String, dynamic>>> getTeacherStudents() async {
    final response = await _apiClient.get('/teacher/students');
    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Fetch comments for a specific student
  Future<List<Map<String, dynamic>>> getStudentComments(String studentId) async {
    final response = await _apiClient.get('/teacher/students/$studentId/comments');
    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Add a comment to a student
  Future<void> addComment(String studentId, String content) async {
    await _apiClient.post('/teacher/comments', body: {
      'studentId': studentId,
      'content': content,
    });
  }
}
