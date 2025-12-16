class ServiceModel {
  final int id;
  final String name;
  final String? description;

  ServiceModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // Support both 'name' and 'serviceName' fields from API
    final serviceName = json['serviceName'] ?? json['name'] ?? '';
    return ServiceModel(
      id: json['id'] ?? 0,
      name: serviceName,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}


