class BuildingResponse {
  final String? buildingName;
  final int? buildYear;
  final String? ownerType;
  final int? mortgageAmount;
  final bool isRegistered;
  final int? salePrice;
  final String? jeonseRatio;
  const BuildingResponse({
    this.buildingName,
    this.buildYear,
    this.ownerType,
    this.mortgageAmount,
    required this.isRegistered,
    this.salePrice,
    this.jeonseRatio,
  });

  factory BuildingResponse.fromJson(Map<String, dynamic> json) {
    return BuildingResponse(
      buildingName: json['building_name'] as String?,
      buildYear: json['build_year'] as int?,
      ownerType: json['owner_type'] as String?,
      mortgageAmount: json['mortgage_amount'] as int?,
      isRegistered: json['is_registered'] as bool,
      salePrice: json['sale_price'] as int?,
      jeonseRatio: json['jeonse_ratio'] as String?,
    );
  }
}
