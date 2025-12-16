import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/recipt_voucher/data/datasources/receipt_voucher_remote_data_source.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_service_model.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_options_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';

part 'new_receipt_voucher_state.dart';

class NewReceiptVoucherCubit extends Cubit<NewReceiptVoucherState> {
  final ReceiptVoucherRemoteDataSource voucherDataSource;
  final BookingOptionsRemoteDataSource optionsDataSource;

  NewReceiptVoucherCubit(
    this.voucherDataSource,
    this.optionsDataSource,
  ) : super(NewReceiptVoucherInitial());

  String _guestName = '';
  String? _location;
  int? _locationId;
  int? _currencyId = 1;
  String? _phoneNumber;
  String _status = 'PENDING';
  String? _hotel;
  int? _room;
  String? _note;
  String? _being;
  String? _pickupTime;
  String? _pickupStatus;
  String? _driver;
  int? _carNumber;
  String _payment = 'CASH ON CAMP';
  bool _isMyClient = true;
  int? _employeeAddedId;
  String _typeOperation = 'SERVICE';
  bool _employeeIsReceivedCommission = false;
  int? _discountPercentage;
  List<ReceiptVoucherServiceModel> _services = [];
  int _adultCount = 0;
  int _childCount = 0;
  int _kidCount = 0;

  List<LocationModel> _locations = [];
  List<ServiceModel> _servicesList = [];
  List<HotelModel> _hotels = [];

  String get guestName => _guestName;
  String? get location => _location;
  int? get locationId => _locationId;
  int? get currencyId => _currencyId;
  String? get phoneNumber => _phoneNumber;
  String get status => _status;
  String? get hotel => _hotel;
  int? get room => _room;
  String? get note => _note;
  String? get being => _being;
  String? get pickupTime => _pickupTime;
  String? get pickupStatus => _pickupStatus;
  String? get driver => _driver;
  int? get carNumber => _carNumber;
  String get payment => _payment;
  bool get isMyClient => _isMyClient;
  int? get employeeAddedId => _employeeAddedId;
  String get typeOperation => _typeOperation;
  bool get employeeIsReceivedCommission => _employeeIsReceivedCommission;
  int? get discountPercentage => _discountPercentage;
  List<ReceiptVoucherServiceModel> get services => _services;
  int get adultCount => _adultCount;
  int get childCount => _childCount;
  int get kidCount => _kidCount;
  List<LocationModel> get locations => _locations;
  List<ServiceModel> get servicesList => _servicesList;
  List<HotelModel> get hotels => _hotels;

  double get priceBeforePercentage {
    return _services.fold(0.0, (sum, service) => sum + service.totalPrice);
  }

  double get priceAfterPercentage {
    if (_discountPercentage == null || _discountPercentage == 0) {
      return priceBeforePercentage;
    }
    return priceBeforePercentage * (1 - _discountPercentage! / 100);
  }

  double get finalPriceWithCommissionEmployee => priceAfterPercentage;
  double get finalPriceAfterDeductingCommissionEmployee => priceAfterPercentage;

  Future<void> init() async {
    emit(NewReceiptVoucherLoading());
    try {
      _locations = await optionsDataSource.getAllLocations();
      _servicesList = await optionsDataSource.getAllServices();
      _hotels = await optionsDataSource.getHotels();
      emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
    } catch (e) {
      emit(NewReceiptVoucherError(e.toString()));
    }
  }

  void updateGuestName(String value) {
    _guestName = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length));
  }

  void updateLocation(String? location, int? locationId) {
    _location = location;
    _locationId = locationId;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateCurrencyId(int? value) {
    _currencyId = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updatePhoneNumber(String? value) {
    _phoneNumber = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateHotel(String? value) {
    _hotel = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateRoom(int? value) {
    _room = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateNote(String? value) {
    _note = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateBeing(String? value) {
    _being = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updatePayment(String value) {
    _payment = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateDiscountPercentage(int? value) {
    _discountPercentage = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateAdultCount(int value) {
    _adultCount = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateChildCount(int value) {
    _childCount = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateKidCount(int value) {
    _kidCount = value;
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateService(
    int index,
    int serviceId,
    String serviceName,
    int adultNumber,
    int childNumber,
    int kidNumber,
    double adultPrice,
    double childPrice,
    double kidPrice,
  ) {
    if (index >= 0 && index < _services.length) {
      final total = (adultNumber * adultPrice) +
          (childNumber * childPrice) +
          (kidNumber * kidPrice);
      _services[index] = ReceiptVoucherServiceModel(
        id: _services[index].id,
        serviceId: serviceId,
        serviceName: serviceName,
        adultNumber: adultNumber,
        childNumber: childNumber,
        kidNumber: kidNumber,
        adultPrice: adultPrice,
        childPrice: childPrice,
        kidPrice: kidPrice,
        totalPrice: total,
      );
      emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
    }
  }

  void addService(ServiceModel service) {
    final serviceModel = ReceiptVoucherServiceModel(
      id: 0,
      serviceId: service.id,
      serviceName: service.name,
      adultNumber: 1,
      childNumber: _childCount,
      kidNumber: _kidCount,
      adultPrice: 0.0,
      childPrice: 0.0,
      kidPrice: 0.0,
      totalPrice: 0.0,
    );
    _services.add(serviceModel);
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void removeService(int index) {
    if (index >= 0 && index < _services.length) {
      _services.removeAt(index);
      emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
    }
  }

  Future<void> addEmptyService() async {
    emit(NewReceiptVoucherAddingService());
    await Future.delayed(const Duration(milliseconds: 100));
    final emptyService = ReceiptVoucherServiceModel(
      id: 0,
      serviceId: 0,
      serviceName: null,
      adultNumber: 1,
      childNumber: 0,
      kidNumber: 0,
      adultPrice: 0.0,
      childPrice: 0.0,
      kidPrice: 0.0,
      totalPrice: 0.0,
    );
    _services.add(emptyService);
    emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
  }

  void updateServicePrice(int index, double adultPrice, double childPrice, double kidPrice) {
    if (index >= 0 && index < _services.length) {
      final service = _services[index];
      final total = (service.adultNumber * adultPrice) +
          (service.childNumber * childPrice) +
          (service.kidNumber * kidPrice);
      _services[index] = ReceiptVoucherServiceModel(
        id: service.id,
        serviceId: service.serviceId,
        serviceName: service.serviceName,
        adultNumber: service.adultNumber,
        childNumber: service.childNumber,
        kidNumber: service.kidNumber,
        adultPrice: adultPrice,
        childPrice: childPrice,
        kidPrice: kidPrice,
        totalPrice: total,
      );
      emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
    }
  }

  void updateServiceNumbers(int index, int adultNumber, int childNumber, int kidNumber) {
    if (index >= 0 && index < _services.length) {
      final service = _services[index];
      final total = (adultNumber * service.adultPrice) +
          (childNumber * service.childPrice) +
          (kidNumber * service.kidPrice);
      _services[index] = ReceiptVoucherServiceModel(
        id: service.id,
        serviceId: service.serviceId,
        serviceName: service.serviceName,
        adultNumber: adultNumber,
        childNumber: childNumber,
        kidNumber: kidNumber,
        adultPrice: service.adultPrice,
        childPrice: service.childPrice,
        kidPrice: service.kidPrice,
        totalPrice: total,
      );
      emit(NewReceiptVoucherLoaded(servicesCount: _services.length, timestamp: DateTime.now()));
    }
  }

  bool areServicesValid() {
    for (final service in _services) {
      if (service.serviceId == 0) continue;
      
      if (service.adultPrice > 0 && service.adultNumber <= 0) {
        return false;
      }
      if (service.childPrice > 0 && service.childNumber <= 0) {
        return false;
      }
      if (service.kidPrice > 0 && service.kidNumber <= 0) {
        return false;
      }
    }
    return true;
  }

  Future<void> saveVoucher() async {
    if (_guestName.isEmpty) {
      emit(NewReceiptVoucherError('receipt_voucher.guest_name_required'));
      return;
    }
    if (_locationId == null) {
      emit(NewReceiptVoucherError('receipt_voucher.location_required'));
      return;
    }
    if (_services.isEmpty) {
      emit(NewReceiptVoucherError('receipt_voucher.at_least_one_service_required'));
      return;
    }
    if (!areServicesValid()) {
      emit(NewReceiptVoucherError('receipt_voucher.service_price_number_required'));
      return;
    }

    emit(NewReceiptVoucherSaving());
    try {
      final voucher = ReceiptVoucherModel(
        id: 0,
        createAt: '',
        guestName: _guestName,
        location: _location,
        locationId: _locationId,
        currencyId: _currencyId,
        phoneNumber: _phoneNumber,
        status: _status,
        hotel: _hotel,
        room: _room,
        note: _note,
        pickupTime: _pickupTime,
        pickupStatus: _pickupStatus,
        driver: _driver,
        carNumber: _carNumber,
        payment: _payment,
        employeeAddedId: _employeeAddedId,
        employeeAddedName: null,
        commissionEmployee: null,
        typeOperation: _typeOperation,
        employeeIsReceivedCommission: _employeeIsReceivedCommission,
        discountPercentage: _discountPercentage,
        services: _services,
        priceBeforePercentage: priceBeforePercentage,
        priceAfterPercentage: priceAfterPercentage,
        finalPriceWithCommissionEmployee: finalPriceWithCommissionEmployee,
        finalPriceAfterDeductingCommissionEmployee: finalPriceAfterDeductingCommissionEmployee,
      );
      await voucherDataSource.createReceiptVoucher(voucher);
      emit(NewReceiptVoucherSaved());
    } catch (e) {
      emit(NewReceiptVoucherError(e.toString()));
    }
  }
}

