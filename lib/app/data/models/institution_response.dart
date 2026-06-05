class InstitutionItem {
  final String name;
  final String phone;
  final String address;

  const InstitutionItem({
    required this.name,
    required this.phone,
    required this.address,
  });

  factory InstitutionItem.fromJson(Map<String, dynamic> json) {
    return InstitutionItem(
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );
  }
}

class InstitutionResponse {
  final String region;
  final List<InstitutionItem> institutions;

  const InstitutionResponse({
    required this.region,
    required this.institutions,
  });

  factory InstitutionResponse.fromJson(Map<String, dynamic> json) {
    return InstitutionResponse(
      region: json['region'] as String,
      institutions: (json['institutions'] as List)
          .map((e) => InstitutionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
