import 'package:blossom_app/services/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'api_config.dart';

// Thin wrapper around Dio calls to the Submission-related endpoints.
// Controllers/pages call these methods rather than using Dio directly,
// keeping HTTP details out of the UI layer.
class SubmissionApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: kApiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ))..interceptors.add(AuthInterceptor());

  // GET /submission-types — active types only, for the "create new" picker
  Future<List<dynamic>> getSubmissionTypes() async {
    final response = await _dio.get('/submission-types');
    return response.data as List<dynamic>;
  }

  // POST /submissions
  Future<int> createSubmission({
    required int submissionTypeId,
    required int personnelId,
    required String title,
    String? description,
  }) async {
    final response = await _dio.post('/submissions', data: {
      'SubmissionTypeID': submissionTypeId,
      'PersonnelID': personnelId,
      'Title': title,
      'Description': description ?? '',
    });
    final id = response.data['SubmissionID'];
    return id is int ? id : int.parse(id.toString());
  }

  // GET /submissions/personnel/{id} — Submissions created by a Pekerja
  Future<List<dynamic>> getSubmissionsForPersonnel(int personnelId) async {
    final response = await _dio.get('/submissions/personnel/$personnelId');
    return response.data as List<dynamic>;
  }

  // GET /submissions/pending/{id} — Submissions awaiting this Personnel's decision
  Future<List<dynamic>> getPendingForPersonnel(int personnelId) async {
    final response = await _dio.get('/submissions/pending/$personnelId');
    return response.data as List<dynamic>;
  }

  // GET /submissions/{id}/history
  Future<List<dynamic>> getHistory(int submissionId) async {
    final response = await _dio.get('/submissions/$submissionId/history');
    return response.data as List<dynamic>;
  }

  // POST /submissions/{id}/decision
  Future<void> submitDecision({
    required int submissionId,
    required String decision, // 'Approved' | 'Rejected'
    required int personnelId,
    bool isOverride = false,
  }) async {
    await _dio.post('/submissions/$submissionId/decision', data: {
      'Decision': decision,
      'PersonnelID': personnelId,
      'IsOverride': isOverride,
    });
  }
}