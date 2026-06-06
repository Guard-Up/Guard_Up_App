class AnalyzeImageResponse {
  final String sessionId;
  final String ocrText;
  final String maskedText;
  final String? address;

  const AnalyzeImageResponse({
    required this.sessionId,
    required this.ocrText,
    required this.maskedText,
    this.address,
  });

  factory AnalyzeImageResponse.fromJson(Map<String, dynamic> json) {
    return AnalyzeImageResponse(
      sessionId: json['session_id'] as String,
      ocrText: json['ocr_text'] as String,
      maskedText: json['masked_text'] as String,
      address: json['address'] as String?,
    );
  }
}
