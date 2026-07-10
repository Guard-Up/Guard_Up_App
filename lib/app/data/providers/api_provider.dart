import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../models/analyze_image_response.dart';
import '../models/verify_address_response.dart';
import '../models/building_response.dart';
import '../models/risk_analysis_response.dart';
import '../models/institution_response.dart';

class ApiException implements Exception {
  final String errorCode;
  final String message;
  final int statusCode;

  const ApiException({
    required this.errorCode,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiException($statusCode): $errorCode - $message';
}

class ApiProvider {
  final http.Client _client = http.Client();

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  void dispose() => _client.close();

  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw ApiException(
        statusCode: response.statusCode,
        errorCode: body['error_code'] as String? ?? 'UNKNOWN_ERROR',
        message: body['message'] as String? ?? 'Unknown error occurred',
      );
    }
  }

  // 자립지원 전담기관 조회 (지역별)
  Future<InstitutionResponse> getInstitution(String region) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.institution}'),
          headers: _headers,
          body: jsonEncode({'region': region}),
        )
        .timeout(ApiConstants.requestTimeout);
 
    _handleError(response);
    return InstitutionResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // 1단계: 계약서 이미지 분석 (1장·여러 장 모두 지원)
  // 여러 장이면 같은 필드명 'file'을 반복해서 담는다. (백엔드 스펙)
  Future<AnalyzeImageResponse> analyzeImage(List<String> imagePaths) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.analyzeImage}'),
    );
    for (final path in imagePaths) {
      request.files.add(await http.MultipartFile.fromPath('file', path));
    }

    final streamed = await request.send().timeout(ApiConstants.requestTimeout);
    final response = await http.Response.fromStream(streamed);

    _handleError(response);
    return AnalyzeImageResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // 2단계: 주소 검증
  Future<VerifyAddressResponse> verifyAddress(
      String sessionId, String address) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.verifyAddress}'),
          headers: _headers,
          body: jsonEncode({'session_id': sessionId, 'address': address}),
        )
        .timeout(ApiConstants.requestTimeout);

    _handleError(response);
    return VerifyAddressResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // 3단계: 건물 정보 조회
  Future<BuildingResponse> getBuilding(
      String sessionId, String roadAddress) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.building}'),
          headers: _headers,
          body: jsonEncode(
              {'session_id': sessionId, 'road_address': roadAddress}),
        )
        .timeout(ApiConstants.requestTimeout);

    _handleError(response);
    return BuildingResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // 4단계: AI 리스크 분석
  Future<RiskAnalysisResponse> analyzeRisk(String sessionId) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.analyzeRisk}'),
          headers: _headers,
          body: jsonEncode({'session_id': sessionId}),
        )
        .timeout(ApiConstants.requestTimeout);

    _handleError(response);
    return RiskAnalysisResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }
}
