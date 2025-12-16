import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';
import 'package:the_dunes/features/login/data/models/permissions_model.dart';

part 'new_employee_state.dart';

class NewEmployeeCubit extends Cubit<NewEmployeeState> {
  final EmployeeRepository repository;

  NewEmployeeCubit(this.repository) : super(NewEmployeeInitial());

  String _name = '';
  String _email = '';
  String _password = '';
  String? _phoneNumber;
  String? _position;
  bool _isEmarat = false;
  double? _visaCost;
  bool _isSalary = false;
  bool _isCommission = false;
  double? _salary;
  double? _commission;
  String? _areaOfLocation;
  String? _hotel;
  String? _startVisa;
  String? _endVisa;
  bool _controlSystem = true;
  String? _imagePath;
  String? _imageFileName;
  Uint8List? _imageBytes;
  PermissionsModel _permissions = PermissionsModel();
  // Separate UI state for "any" vs "me" permissions
  final Map<String, bool> _uiPermissions = {};

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String? get phoneNumber => _phoneNumber;
  String? get position => _position;
  bool get isEmarat => _isEmarat;
  double? get visaCost => _visaCost;
  bool get isSalary => _isSalary;
  bool get isCommission => _isCommission;
  double? get salary => _salary;
  double? get commission => _commission;
  String? get areaOfLocation => _areaOfLocation;
  String? get hotel => _hotel;
  String? get startVisa => _startVisa;
  String? get endVisa => _endVisa;
  bool get controlSystem => _controlSystem;
  String? get imagePath => _imagePath;
  String? get imageFileName => _imageFileName;
  Uint8List? get imageBytes => _imageBytes;
  PermissionsModel get permissions => _permissions;

  void updateName(String value) {
    _name = value;
    emit(NewEmployeeFormUpdated());
  }

  void updateEmail(String value) {
    _email = value;
    emit(NewEmployeeFormUpdated());
  }

  void updatePassword(String value) {
    _password = value;
    emit(NewEmployeeFormUpdated());
  }

  void updatePhoneNumber(String? value) {
    _phoneNumber = value?.isEmpty == true ? null : value;
    emit(NewEmployeeFormUpdated());
  }

  void updatePosition(String? value) {
    _position = value;
    
    // Auto-select permissions based on position
    if (value != null) {
      _selectPermissionsByPosition(value);
    }
    
    emit(NewEmployeeFormUpdated(updatedPermissionKey: 'position_$value'));
  }

  void _selectPermissionsByPosition(String position) {
    // Clear all permissions first
    _uiPermissions.clear();
    
    switch (position) {
      case 'Owner':
      case 'Operation Manager':
      case 'Operation Assistant':
        // Select all permissions
        _selectAllPermissions();
        break;
      
      case 'Desk Agent':
        // Select only specific permissions in receipt voucher (as shown in image)
        _uiPermissions['showReceiptVoucherAdded'] = true; // Show My Receipt Vouchers
        _uiPermissions['addNewReceiptVoucherMe'] = true; // Add New Receipt Voucher
        break;
      
      case 'Camp Agent':
        // Select only specific permissions in receipt voucher + all camp booking
        _uiPermissions['showReceiptVoucherAdded'] = true; // Show My Receipt Vouchers
        _uiPermissions['addNewReceiptVoucherMe'] = true; // Add New Receipt Voucher
        _uiPermissions['showAllCampBookings'] = true;
        _uiPermissions['changeStateBooking'] = true;
        break;
    }
    
    // Update backend permissions
    final permissionsMap = _permissions.toJson();
    _updateBackendPermissions(permissionsMap);
    _permissions = PermissionsModel.fromJson(permissionsMap);
  }

  void _selectAllPermissions() {
    // Receipt Voucher Screen
    _uiPermissions['showAllReceiptVoucher'] = true;
    _uiPermissions['showReceiptVoucherAdded'] = true;
    _uiPermissions['addNewReceiptVoucherMe'] = true;
    _uiPermissions['addNewReceiptVoucherOtherEmployee'] = true;
    _uiPermissions['editReceiptVoucher'] = true;
    _uiPermissions['editReceiptVoucherMe'] = true;
    _uiPermissions['deleteReceiptVoucher'] = true;
    _uiPermissions['deleteReceiptVoucherMe'] = true;
    
    // Booking Screen
    _uiPermissions['showAllBooking'] = true;
    _uiPermissions['showMyBookAdded'] = true;
    _uiPermissions['addNewBook'] = true;
    _uiPermissions['editBook'] = true;
    _uiPermissions['editBookMe'] = true;
    _uiPermissions['deleteBook'] = true;
    _uiPermissions['deleteBookMe'] = true;
    
    // Pickup Time Screen
    _uiPermissions['showAllPickup'] = true;
    _uiPermissions['editAnyPickup'] = true;
    
    // Service Screen
    _uiPermissions['showAllService'] = true;
    _uiPermissions['addNewService'] = true;
    _uiPermissions['editService'] = true;
    _uiPermissions['deleteService'] = true;
    
    // Hotel Screen
    _uiPermissions['showAllHotels'] = true;
    _uiPermissions['addNewHotels'] = true;
    _uiPermissions['editHotels'] = true;
    _uiPermissions['deleteHotels'] = true;
    
    // Camp Screen
    _uiPermissions['showAllCampBookings'] = true;
    _uiPermissions['changeStateBooking'] = true;
    
    // Employee Screen
    _uiPermissions['showAllEmployees'] = true;
    _uiPermissions['addNewEmployee'] = true;
    _uiPermissions['editAnyEmployees'] = true;
    _uiPermissions['changeStateAnyEmployees'] = true;
    
    // Operations Screen
    _uiPermissions['showAllOperations'] = true;
    _uiPermissions['addNewOperation'] = true;
    _uiPermissions['editOperation'] = true;
    _uiPermissions['deleteOperation'] = true;
    
    // Analysis Screen
    _uiPermissions['analysisScreen'] = true;
    
    // Setting Screen
    _uiPermissions['settingScreen'] = true;
  }

  void updateIsEmarat(bool value) {
    _isEmarat = value;
    emit(NewEmployeeFormUpdated(updatedPermissionKey: 'isEmarat_$value'));
  }

  void updateVisaCost(double? value) {
    _visaCost = value;
    emit(NewEmployeeFormUpdated());
  }

  void updateIsSalary(bool value) {
    _isSalary = value;
    _isCommission = !value;
    emit(NewEmployeeFormUpdated());
  }

  void updateIsCommission(bool value) {
    _isCommission = value;
    _isSalary = !value;
    emit(NewEmployeeFormUpdated());
  }

  void updateSalaryType(bool isSalary, bool isCommission) {
    _isSalary = isSalary;
    _isCommission = isCommission;
    emit(NewEmployeeFormUpdated(updatedPermissionKey: 'salaryType_${isSalary}_$isCommission'));
  }

  void updateSalary(double? value) {
    _salary = value;
    emit(NewEmployeeFormUpdated());
  }

  void updateCommission(double? value) {
    _commission = value;
    emit(NewEmployeeFormUpdated());
  }

  void updateAreaOfLocation(String? value) {
    _areaOfLocation = value;
    emit(NewEmployeeFormUpdated());
  }

  void updateHotel(String? value) {
    _hotel = value;
    emit(NewEmployeeFormUpdated());
  }

  void updateStartVisa(String? value) {
    _startVisa = value;
    emit(NewEmployeeFormUpdated(updatedPermissionKey: 'startVisa_$value'));
  }

  void updateEndVisa(String? value) {
    _endVisa = value;
    emit(NewEmployeeFormUpdated(updatedPermissionKey: 'endVisa_$value'));
  }

  void updateControlSystem(bool value) {
    _controlSystem = value;
    emit(NewEmployeeFormUpdated(updatedPermissionKey: 'controlSystem_$value'));
  }

  void updateImagePath(String? path) {
    _imagePath = path;
    _imageFileName = null;
    _imageBytes = null;
    emit(NewEmployeeFormUpdated());
  }

  void updateImageFile(String fileName, Uint8List bytes) {
    _imageFileName = fileName;
    _imageBytes = bytes;
    _imagePath = fileName; // Store file name for display
    emit(NewEmployeeFormUpdated());
  }

  void clearImage() {
    _imagePath = null;
    _imageFileName = null;
    _imageBytes = null;
    emit(NewEmployeeFormUpdated(updatedPermissionKey: 'image_cleared'));
  }

  void updatePermission(String key, bool value) {
    // Store UI state separately - this is the source of truth for UI
    _uiPermissions[key] = value;
    
    // Update backend permissions based on UI state
    final permissionsMap = _permissions.toJson();
    _updateBackendPermissions(permissionsMap);
    _permissions = PermissionsModel.fromJson(permissionsMap);
    
    // Emit new state to trigger rebuild - include value in key to ensure different state
    emit(NewEmployeeFormUpdated(updatedPermissionKey: '${key}_$value'));
  }

  void _updateBackendPermissions(Map<String, dynamic> permissionsMap) {
    // First, reset all permissions to false
    permissionsMap.forEach((key, value) {
      if (value is bool) {
        permissionsMap[key] = false;
      }
    });
    
    // Then, map UI permissions to backend permissions
    // Each checkbox is independent - no cross-dependencies
    for (final entry in _uiPermissions.entries) {
      final key = entry.key;
      // Skip global permission keys (they're UI-only)
      if (key.startsWith('global_')) continue;
      
      // For permissions that have "any" and "me" variants in UI but single backend key:
      // Set backend permission to true if ANY of the UI variants is checked
      if (key == 'editReceiptVoucher' || key == 'editReceiptVoucherMe') {
        final anyChecked = _uiPermissions['editReceiptVoucher'] ?? false;
        final meChecked = _uiPermissions['editReceiptVoucherMe'] ?? false;
        permissionsMap['editReceiptVoucher'] = anyChecked || meChecked;
      } else if (key == 'deleteReceiptVoucher' || key == 'deleteReceiptVoucherMe') {
        final anyChecked = _uiPermissions['deleteReceiptVoucher'] ?? false;
        final meChecked = _uiPermissions['deleteReceiptVoucherMe'] ?? false;
        permissionsMap['deleteReceiptVoucher'] = anyChecked || meChecked;
      } else if (key == 'editBook' || key == 'editBookMe') {
        final anyChecked = _uiPermissions['editBook'] ?? false;
        final meChecked = _uiPermissions['editBookMe'] ?? false;
        permissionsMap['editBook'] = anyChecked || meChecked;
      } else if (key == 'deleteBook' || key == 'deleteBookMe') {
        final anyChecked = _uiPermissions['deleteBook'] ?? false;
        final meChecked = _uiPermissions['deleteBookMe'] ?? false;
        permissionsMap['deleteBook'] = anyChecked || meChecked;
      } else {
        // Direct mapping for other permissions
        permissionsMap[key] = entry.value;
      }
    }
  }

  bool getUIPermission(String key) {
    // Return the UI state directly - this is the source of truth
    final value = _uiPermissions[key];
    return value ?? false;
  }

  Future<void> createEmployee() async {
    emit(NewEmployeeLoading());
    try {
      final data = _buildFormData();
      final files = _buildImageFiles();
      
      if (kDebugMode) {
        debugPrint('[NewEmployeeCubit] Creating employee...');
        debugPrint('[NewEmployeeCubit] Has image: ${files != null && files.isNotEmpty}');
        debugPrint('[NewEmployeeCubit] Image bytes length: ${_imageBytes?.length ?? 0}');
        debugPrint('[NewEmployeeCubit] Form data: $data');
      }
      
      await repository.createEmployee(data, files: files);
      emit(NewEmployeeSuccess('employees.create_success'.tr()));
    } catch (e) {
      emit(NewEmployeeError(e.toString()));
    }
  }

  Map<String, dynamic> _buildFormData() {
    final data = <String, dynamic>{
      'name': _name,
      'email': _email,
      'password': _password,
      'position': _position ?? '',
      'isEmarat': _isEmarat.toString(),
      'isSalary': _isSalary.toString(),
      'isCommission': _isCommission.toString(),
    };

    if (_phoneNumber != null && _phoneNumber!.isNotEmpty) {
      data['phoneNumber'] = _phoneNumber!;
    }
    if (_visaCost != null) {
      data['visaCost'] = _visaCost!.toString();
    }
    if (_salary != null) {
      data['salary'] = _salary!.toString();
    }
    if (_commission != null) {
      data['commission'] = _commission!.toString();
    }
    if (_areaOfLocation != null && _areaOfLocation!.isNotEmpty) {
      data['areaOfLocation'] = _areaOfLocation!;
    }
    if (_hotel != null && _hotel!.isNotEmpty) {
      data['hotel'] = _hotel!;
    }
    if (_startVisa != null && _startVisa!.isNotEmpty) {
      data['startVisa'] = _startVisa!;
    }
    if (_endVisa != null && _endVisa!.isNotEmpty) {
      data['endVisa'] = _endVisa!;
    }

    data['permissions'] = jsonEncode(_permissions.toJson());

    return data;
  }

  Map<String, Uint8List>? _buildImageFiles() {
    if (_imageBytes != null && _imageBytes!.isNotEmpty) {
      return {'image': _imageBytes!};
    }
    return null;
  }
}

