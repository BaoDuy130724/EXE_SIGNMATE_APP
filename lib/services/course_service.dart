import 'api_client.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';

class CourseService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches a list of all courses, optionally filtered by search or level
  Future<List<CourseModel>> getCourses({String? search, String? level}) async {
    String query = '';
    if (search != null || level != null) {
      final params = <String>[];
      if (search != null) params.add('search=$search');
      if (level != null) params.add('level=$level');
      query = '?${params.join('&')}';
    }

    final response =
        await _apiClient.get('/courses$query', requiresAuth: false);
    if (response is List) {
      return response.map((e) => CourseModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Fetches detailed information for a specific course by ID
  Future<CourseModel> getCourse(String id) async {
    final response = await _apiClient.get('/courses/$id', requiresAuth: false);
    return CourseModel.fromJson(response);
  }

  /// Fetches all lessons for a specific course
  Future<List<LessonModel>> getLessonsForCourse(String courseId) async {
    final response =
        await _apiClient.get('/courses/$courseId/lessons', requiresAuth: false);
    if (response is List) {
      return response.map((e) => LessonModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Fetches details for a specific lesson
  Future<LessonModel> getLesson(String id) async {
    final response = await _apiClient.get('/lessons/$id', requiresAuth: false);
    return LessonModel.fromJson(response);
  }

  /// Enrolls the current user in a course
  Future<void> enrollInCourse(String courseId) async {
    await _apiClient.post('/enrollments', body: {'courseId': courseId});
  }

  /// Create a new course (Teacher, Admin)
  Future<CourseModel> createCourse(Map<String, dynamic> courseData) async {
    final response = await _apiClient.post('/courses', body: courseData);
    return CourseModel.fromJson(response);
  }

  /// Update a course (Teacher, Admin)
  Future<CourseModel> updateCourse(
      String id, Map<String, dynamic> courseData) async {
    final response = await _apiClient.put('/courses/$id', body: courseData);
    return CourseModel.fromJson(response);
  }

  /// Get current user's enrolled courses and progress
  Future<List<dynamic>> getMyEnrollments() async {
    final response = await _apiClient.get('/enrollments/me');
    return response is List ? response : [];
  }

  /// Upload Reference Video for AI Dataset (Teacher, Admin)
  Future<Map<String, dynamic>> uploadSignReferenceVideo(String signId, String videoPath) async {
    final response = await _apiClient.postMultipart('/vocabulary/$signId/upload-reference', filePath: videoPath);
    return response as Map<String, dynamic>;
  }
}
