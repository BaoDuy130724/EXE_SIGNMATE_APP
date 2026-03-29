import 'api_client.dart';
import '../models/center_model.dart';
import '../models/class_model.dart';

class CenterService {
  final ApiClient _apiClient = ApiClient();

  /// Get all centers
  Future<List<CenterModel>> getCenters() async {
    final response = await _apiClient.get('/centers');
    if (response is List) {
      return response.map((e) => CenterModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getCenterDashboard(String id) async {
    final response = await _apiClient.get('/centers/$id/dashboard');
    return response as Map<String, dynamic>;
  }

  /// Get classes for a specific center
  Future<List<ClassModel>> getClasses(String centerId) async {
    final response = await _apiClient.get('/centers/$centerId/classes');
    if (response is List) {
      return response.map((e) => ClassModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Track class analytics and get students
  Future<ClassModel> trackClass(String classId) async {
    final response = await _apiClient.get('/tracking/classes/$classId/students');
    return ClassModel.fromJson(response);
  }

  /// Submit a B2B contact lead form
  Future<void> submitB2BContact(Map<String, dynamic> data) async {
    await _apiClient.post('/b2b/contact', body: data, requiresAuth: false);
  }

  /// Create a center (SuperAdmin)
  Future<CenterModel> createCenter(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/centers', body: data);
    return CenterModel.fromJson(response);
  }

  /// Create a class in a center (CenterAdmin)
  Future<ClassModel> createClass(String centerId, Map<String, dynamic> data) async {
    final response = await _apiClient.post('/centers/$centerId/classes', body: data);
    return ClassModel.fromJson(response);
  }

  /// Add students to class (CenterAdmin)
  Future<void> addStudentsToClass(String centerId, String classId, List<String> studentIds) async {
    await _apiClient.post('/centers/$centerId/classes/$classId/students', body: {'studentIds': studentIds});
  }

  /// Get students in class (CenterAdmin, Teacher)
  Future<List<dynamic>> getStudentsInClass(String centerId, String classId) async {
    final response = await _apiClient.get('/centers/$centerId/classes/$classId/students');
    return response is List ? response : [];
  }

  /// Assign a lesson to class (CenterAdmin, Teacher)
  Future<void> assignLessonToClass(String centerId, String classId, String lessonId) async {
    await _apiClient.post('/centers/$centerId/classes/$classId/lessons', body: {'lessonId': lessonId});
  }

  /// Add teacher comment to student (CenterAdmin, Teacher)
  Future<void> addTeacherComment(Map<String, dynamic> data) async {
    await _apiClient.post('/teacher/comments', body: data);
  }

  /// Get comments for a student (CenterAdmin, Teacher)
  Future<List<dynamic>> getStudentComments(String studentId) async {
    final response = await _apiClient.get('/teacher/students/$studentId/comments');
    return response is List ? response : [];
  }

  /// Generate center reports (CenterAdmin)
  Future<Map<String, dynamic>> generateCenterReports(String centerId) async {
    final response = await _apiClient.get('/tracking/centers/$centerId/reports');
    return response as Map<String, dynamic>;
  }
}
