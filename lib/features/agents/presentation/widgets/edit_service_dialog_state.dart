import 'package:the_dunes/features/booking/data/models/location_model.dart';

class EditServiceDialogState {
  final List<LocationModel> locations;
  final bool isGlobal;
  final LocationModel? selectedLocation;
  final bool isLoading;

  EditServiceDialogState({
    this.locations = const [],
    this.isGlobal = false,
    this.selectedLocation,
    this.isLoading = true,
  });

  EditServiceDialogState copyWith({
    List<LocationModel>? locations,
    bool? isGlobal,
    LocationModel? selectedLocation,
    bool? isLoading,
  }) {
    return EditServiceDialogState(
      locations: locations ?? this.locations,
      isGlobal: isGlobal ?? this.isGlobal,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

