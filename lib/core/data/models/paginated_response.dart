import 'package:the_dunes/core/data/models/pagination_info.dart';

class PaginatedResponse<T> {
  final bool success;
  final String message;
  final List<T> data;
  final PaginationInfo pagination;
  final double? totalPrice;
  final int? totalCount;

  PaginatedResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
    this.totalPrice,
    this.totalCount,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => fromJsonT(item))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
      totalPrice: json['totalPrice'] != null
          ? (json['totalPrice'] as num).toDouble()
          : null,
      totalCount: json['totalCount'] as int?,
    );
  }
}

