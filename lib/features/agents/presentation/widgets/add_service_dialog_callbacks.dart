import 'package:the_dunes/features/agents/presentation/widgets/add_service_dialog_state.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';

class AddServiceDialogCallbacks {
  final AddServiceDialogState Function() getState;
  final void Function(AddServiceDialogState) setState;

  AddServiceDialogCallbacks({
    required this.getState,
    required this.setState,
  });

  void onServiceChanged(ServiceModel? value) {
    setState(getState().copyWith(selectedService: value));
  }

  void onGlobalChanged(bool value) {
    setState(getState().copyWith(isGlobal: value));
  }

  void onLocationChanged(LocationModel? value) {
    setState(getState().copyWith(selectedLocation: value));
  }
}


