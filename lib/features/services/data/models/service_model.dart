import 'package:the_dunes/features/services/domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required super.id,
    required super.name,
    super.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
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


