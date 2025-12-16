import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';

class HotelModel extends HotelEntity {
  HotelModel({
    required super.id,
    required super.name,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] ?? 0,
      name: json['nameHotel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameHotel': name,
    };
  }
}

