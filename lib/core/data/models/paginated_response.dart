import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:the_dunes/core/data/models/pagination_info.dart';

class PaginatedResponse<T> {
  final bool success;
  final String message;
  final List<T> data;
  final PaginationInfo pagination;
  final double? totalPrice;
  final int? totalCount;
  final Map<String, dynamic>? statistics;

  PaginatedResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
    this.totalPrice,
    this.totalCount,
    this.statistics,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    debugStatistics(json);
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
      statistics: json['statistics'] as Map<String, dynamic>?,
    );
  }
  
  static void debugStatistics(Map<String, dynamic> json) {
    if (kDebugMode && json['statistics'] != null) {
      print('[PaginatedResponse] Statistics found: ${json['statistics']}');
    } else if (kDebugMode) {
      print('[PaginatedResponse] Statistics is null or missing');
    }
  }
}

