import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/datasources/document_analysis_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/models/agent_model.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/matched_data_model.dart';
import 'package:the_dunes/features/booking/data/models/document_analysis_response_model.dart';
import 'package:the_dunes/features/booking/data/models/service_agent_model.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row_converter.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_service.dart';

part 'document_analysis_state.dart';

class DocumentAnalysisCubit extends Cubit<DocumentAnalysisState> {
  final DocumentAnalysisRemoteDataSource analysisDataSource;
  final BookingRemoteDataSource bookingDataSource;

  DocumentAnalysisCubit(
    this.analysisDataSource,
    this.bookingDataSource,
  ) : super(DocumentAnalysisInitial());

  Future<void> analyzeDocuments(Map<String, Uint8List> files) async {
    if (files.isEmpty) {
      emit(DocumentAnalysisError('booking.no_files_selected'.tr()));
      return;
    }

    emit(DocumentAnalysisLoading());
    try {
      final response = await analysisDataSource.analyzeDocuments(files);
      emit(DocumentAnalysisLoaded(response));
    } catch (e) {
      emit(DocumentAnalysisError(e.toString()));
    }
  }

  Future<void> createBookingsFromMatchedData(
    List<MatchedDataModel> matchedData,
  ) async {
    emit(DocumentAnalysisCreating());
    try {
      final createdBookings = <BookingModel>[];
      for (final data in matchedData) {
        final booking = await _convertMatchedDataToBooking(data);
        final created = await bookingDataSource.createBooking(booking);
        createdBookings.add(created);
      }
      emit(DocumentAnalysisSuccess(
        message: 'booking.bookings_created_success'.tr(),
        createdCount: createdBookings.length,
      ));
    } catch (e) {
      emit(DocumentAnalysisError(e.toString()));
    }
  }

  List<NewBookingRow> convertMatchedDataToBookingRows(
    List<MatchedDataModel> matchedDataList,
  ) {
    return matchedDataList.map((data) {
      final services = data.services.map((service) {
        final serviceAgent = ServiceAgentModel(
          id: service.serviceId ?? 0,
          serviceId: service.serviceId ?? 0,
          serviceName: service.serviceName,
          locationId: service.locationId ?? data.locationId,
          locationName: service.locationName ?? data.locationName,
          adultPrice: service.adultPrice ?? 0.0,
          childPrice: service.childPrice ?? 0.0,
          kidPrice: service.kidPrice ?? 0.0,
        );

        final bookingService = NewBookingService(
          serviceAgent: serviceAgent,
          adult: service.adultNumber,
          child: service.childNumber,
          kid: service.kidNumber,
        );
        bookingService.calculateTotal();
        return bookingService;
      }).toList();

      final row = NewBookingRow(
        guestName: data.guestName,
        phoneNumber: data.phoneNumber,
        location: data.locationId != null && data.locationName != null
            ? LocationModel(id: data.locationId!, name: data.locationName!)
            : null,
        agent: data.agentId != null && data.agentName != null
            ? AgentModel(id: data.agentId!, name: data.agentName!)
            : null,
        hotel: data.hotelName != null
            ? HotelModel(id: 0, name: data.hotelName!)
            : null,
        room: data.room,
        pickupTime: data.pickupTime,
        payment: data.payment ?? 'Cash',
        currency: data.currencyName ?? 'AED',
        services: services,
      );
      row.calculateTotals();
      return row;
    }).toList();
  }

  Future<BookingModel> _convertMatchedDataToBooking(MatchedDataModel data) async {
    final services = data.services.map((service) {
      final serviceAgent = ServiceAgentModel(
        id: service.serviceId ?? 0,
        serviceId: service.serviceId ?? 0,
        serviceName: service.serviceName,
        locationId: service.locationId ?? data.locationId,
        locationName: service.locationName ?? data.locationName,
        adultPrice: service.adultPrice ?? 0.0,
        childPrice: service.childPrice,
        kidPrice: service.kidPrice,
      );

      final bookingService = NewBookingService(
        serviceAgent: serviceAgent,
        adult: service.adultNumber,
        child: service.childNumber,
        kid: service.kidNumber,
      );
      bookingService.calculateTotal();
      return bookingService;
    }).toList();

    final row = NewBookingRow(
      guestName: data.guestName,
      phoneNumber: data.phoneNumber ?? '',
      location: data.locationId != null
          ? LocationModel(id: data.locationId!, name: data.locationName ?? '')
          : null,
      agent: data.agentId != null
          ? AgentModel(id: data.agentId!, name: data.agentName ?? '')
          : null,
      hotel: data.hotelName != null
          ? HotelModel(id: 0, name: data.hotelName!)
          : null,
      room: data.room,
      pickupTime: data.pickupTime ?? '',
      payment: data.payment ?? 'Cash',
      currency: data.currencyName ?? 'AED',
      services: services,
    );
    row.calculateTotals();

    return await NewBookingRowConverter.toBookingModel(row);
  }
}

