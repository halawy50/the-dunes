import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';

class AddServiceDialogState {
  ServiceModel? selectedService;
  LocationModel? selectedLocation;
  bool isGlobal;
  List<ServiceModel> services;
  List<LocationModel> locations;
  bool isLoading;

  AddServiceDialogState({
    this.selectedService,
    this.selectedLocation,
    this.isGlobal = true,
    this.services = const [],
    this.locations = const [],
    this.isLoading = true,
  });

  AddServiceDialogState copyWith({
    ServiceModel? selectedService,
    LocationModel? selectedLocation,
    bool? isGlobal,
    List<ServiceModel>? services,
    List<LocationModel>? locations,
    bool? isLoading,
  }) {
    return AddServiceDialogState(
      selectedService: selectedService ?? this.selectedService,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isGlobal: isGlobal ?? this.isGlobal,
      services: services ?? this.services,
      locations: locations ?? this.locations,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


