class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://35.154.136.12/api';
  static const Duration requestTimeout = Duration(seconds: 60);

  // Endpoints
  static const String analyzeImage = '/analyze/image';
  static const String verifyAddress = '/verify/address';
  static const String building = '/building';
  static const String analyzeRisk = '/analyze/risk';
  static const String institution = '/institution';
  static const String health = '/health';
}
