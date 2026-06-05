class VerifyAddressResponse {
  final bool isValid;
  final String? roadAddress;
  final String? jibunAddress;
  final String? zipCode;
  final String? bjdCode;

  const VerifyAddressResponse({
    required this.isValid,
    this.roadAddress,
    this.jibunAddress,
    this.zipCode,
    this.bjdCode,
  });

  factory VerifyAddressResponse.fromJson(Map<String, dynamic> json) {
    return VerifyAddressResponse(
      isValid: json['is_valid'] as bool,
      roadAddress: json['road_address'] as String?,
      jibunAddress: json['jibun_address'] as String?,
      zipCode: json['zip_code'] as String?,
      bjdCode: json['bjd_code'] as String?,
    );
  }
}
