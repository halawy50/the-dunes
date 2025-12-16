import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/new_receipt_voucher_cubit.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/searchable_hotel_dropdown.dart';

class NewReceiptVoucherForm extends StatelessWidget {
  const NewReceiptVoucherForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        final cubit = context.read<NewReceiptVoucherCubit>();
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RECEPT VOUCHER',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'receipt_voucher.guest_name'.tr() + ' *',
                value: cubit.guestName,
                onChanged: (value) => cubit.updateGuestName(value),
              ),
              const SizedBox(height: 16),
              if (state is NewReceiptVoucherLoading)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'receipt_voucher.hotel_name'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(child: CircularProgressIndicator()),
                  ],
                )
              else
                SearchableHotelDropdown(
                  key: ValueKey('hotels_${cubit.hotels.length}'),
                  value: cubit.hotel,
                  hotels: cubit.hotels,
                  label: 'receipt_voucher.hotel_name'.tr(),
                  onChanged: (value) => cubit.updateHotel(value),
                ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'receipt_voucher.room'.tr() + ' (optional)',
                value: cubit.room?.toString() ?? '',
                keyboardType: TextInputType.number,
                onChanged: (value) => cubit.updateRoom(int.tryParse(value)),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'receipt_voucher.discount'.tr(),
                value: cubit.discountPercentage?.toString() ?? '0',
                keyboardType: TextInputType.number,
                suffixText: '%',
                onChanged: (value) => cubit.updateDiscountPercentage(int.tryParse(value)),
              ),
              const SizedBox(height: 16),
              _buildDropdown<LocationModel>(
                label: 'receipt_voucher.location'.tr() + ' *',
                value: cubit.locationId != null
                    ? cubit.locations.firstWhere(
                        (l) => l.id == cubit.locationId,
                        orElse: () => cubit.locations.isNotEmpty ? cubit.locations.first : throw StateError('No locations available'),
                      )
                    : null,
                items: cubit.locations,
                onChanged: (location) => cubit.updateLocation(location?.name, location?.id),
                displayText: (location) => location.name,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'receipt_voucher.phone_number'.tr(),
                value: cubit.phoneNumber ?? '',
                keyboardType: TextInputType.phone,
                onChanged: (value) => cubit.updatePhoneNumber(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 16),
              _buildCurrencyDropdown(context, cubit),
              const SizedBox(height: 16),
              _buildPaymentDropdown(context, cubit),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'receipt_voucher.note'.tr() + ' (optional)',
                value: cubit.note ?? '',
                maxLines: 3,
                onChanged: (value) => cubit.updateNote(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 24),
              Text(
                'receipt_voucher.services'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildServicesTable(context),
              const SizedBox(height: 16),
              BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
                buildWhen: (previous, current) => 
                    current is NewReceiptVoucherAddingService || 
                    current is NewReceiptVoucherLoaded,
                builder: (context, state) {
                  final cubit = context.read<NewReceiptVoucherCubit>();
                  final isLoading = state is NewReceiptVoucherAddingService;
                  return ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () async {
                            await cubit.addEmptyService();
                          },
                    icon: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.add),
                    label: Text('receipt_voucher.add_service'.tr()),
                  );
                },
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
                  buildWhen: (previous, current) => true,
                  builder: (context, state) {
                    final cubit = context.read<NewReceiptVoucherCubit>();
                    return Text(
                      cubit.priceAfterPercentage.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? suffixText,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: ui.TextDirection.ltr,
          child: TextField(
            key: ValueKey('text_field_$label'),
            controller: TextEditingController(text: value)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: value.length),
              ),
            onChanged: onChanged,
            onTap: onTap,
            keyboardType: keyboardType,
            maxLines: maxLines,
            readOnly: readOnly,
            textDirection: ui.TextDirection.ltr,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              suffixText: suffixText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) displayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(displayText(item)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesTable(BuildContext context) {
    return BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        final cubit = context.read<NewReceiptVoucherCubit>();
        if (cubit.services.isEmpty) {
          return const SizedBox.shrink();
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
            
            final columnWidths = isMobile
                ? const {
                    0: FixedColumnWidth(120),
                    1: FixedColumnWidth(65),
                    2: FixedColumnWidth(65),
                    3: FixedColumnWidth(65),
                    4: FixedColumnWidth(70),
                    5: FixedColumnWidth(70),
                    6: FixedColumnWidth(70),
                    7: FixedColumnWidth(70),
                    8: FixedColumnWidth(50),
                  }
                : isTablet
                    ? const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1.2),
                        5: FlexColumnWidth(1.2),
                        6: FlexColumnWidth(1.2),
                        7: FlexColumnWidth(1.2),
                        8: FixedColumnWidth(50),
                      }
                    : const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1.3),
                        5: FlexColumnWidth(1.3),
                        6: FlexColumnWidth(1.3),
                        7: FlexColumnWidth(1.3),
                        8: FlexColumnWidth(0.8),
                      };
            
            final table = Table(
              border: TableBorder.all(),
              columnWidths: columnWidths,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    _buildTableHeader('receipt_voucher.services'.tr(), isMobile: isMobile),
                    _buildTableHeader('receipt_voucher.adult'.tr(), isMobile: isMobile),
                    _buildTableHeader('receipt_voucher.child'.tr(), isMobile: isMobile),
                    _buildTableHeader('receipt_voucher.kid'.tr(), isMobile: isMobile),
                    _buildTableHeader('receipt_voucher.adult_price'.tr(), isMobile: isMobile),
                    _buildTableHeader('receipt_voucher.child_price'.tr(), isMobile: isMobile),
                    _buildTableHeader('receipt_voucher.kid_price'.tr(), isMobile: isMobile),
                    _buildTableHeader('receipt_voucher.total_price'.tr(), isMobile: isMobile),
                    _buildTableHeader('', width: 30, isMobile: isMobile),
                  ],
                ),
                ...cubit.services.asMap().entries.map((entry) {
                  final index = entry.key;
                  return TableRow(
                    children: [
                      _buildServiceDropdownCell(context, index),
                      _buildNumberCell(context, index, 'adult'),
                      _buildNumberCell(context, index, 'child'),
                      _buildNumberCell(context, index, 'kid'),
                      _buildPriceCell(context, index, 'adult'),
                      _buildPriceCell(context, index, 'child'),
                      _buildPriceCell(context, index, 'kid'),
                      BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
                        buildWhen: (previous, current) => true,
                        builder: (context, state) {
                          final cubit = context.read<NewReceiptVoucherCubit>();
                          if (index < 0 || index >= cubit.services.length) {
                            return _buildTableCell('0.00', isMobile: isMobile);
                          }
                          final service = cubit.services[index];
                          final calculatedTotal = (service.adultNumber * service.adultPrice) +
                              (service.childNumber * service.childPrice) +
                              (service.kidNumber * service.kidPrice);
                          return _buildTableCell(calculatedTotal.toStringAsFixed(2), isMobile: isMobile);
                        },
                      ),
                      _buildTableCell(
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: isMobile ? 18 : 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            final cubit = context.read<NewReceiptVoucherCubit>();
                            cubit.removeService(index);
                          },
                        ),
                        isMobile: isMobile,
                      ),
                    ],
                  );
                }),
              ],
            );
            
            if (isMobile || isTablet) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: table,
              );
            }
            
            return table;
          },
        );
      },
    );
  }

  Widget _buildTableHeader(String text, {double? width, bool isMobile = false}) {
    final padding = isMobile ? 4.0 : 8.0;
    final fontSize = isMobile ? 11.0 : 14.0;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: width != null
          ? SizedBox(
              width: width,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: fontSize,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }

  Widget _buildTableCell(dynamic content, {bool isMobile = false}) {
    final padding = isMobile ? 4.0 : 8.0;
    final fontSize = isMobile ? 11.0 : 14.0;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: content is Widget 
            ? content 
            : Text(
                content.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }

  Widget _buildNumberCell(BuildContext context, int index, String type) {
    return _NumberInputField(
      index: index,
      type: type,
    );
  }

  Widget _buildPriceCell(BuildContext context, int index, String type) {
    return _PriceInputField(
      index: index,
      type: type,
    );
  }

  Widget _buildCurrencyDropdown(BuildContext context, NewReceiptVoucherCubit cubit) {
    final currencies = [
      {'id': 1, 'name': 'AED'},
      {'id': 2, 'name': 'USD'},
      {'id': 3, 'name': 'EUR'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'receipt_voucher.currency'.tr() + ' *',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: cubit.currencyId ?? 1,
          items: currencies.map((currency) {
            return DropdownMenuItem<int>(
              value: currency['id'] as int,
              child: Text(currency['name'] as String),
            );
          }).toList(),
          onChanged: (currencyId) {
            if (currencyId != null) {
              cubit.updateCurrencyId(currencyId);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDropdown(BuildContext context, NewReceiptVoucherCubit cubit) {
    final paymentOptions = ['CASH', 'CARD', 'CASH ON CAMP'];
    return _buildDropdown<String>(
      label: 'receipt_voucher.payment'.tr() + ' *',
      value: cubit.payment,
      items: paymentOptions,
      onChanged: (payment) {
        if (payment != null) {
          cubit.updatePayment(payment);
        }
      },
      displayText: (payment) => payment,
    );
  }

  Widget _buildServiceDropdownCell(BuildContext context, int index) {
    return _SearchableServiceDropdown(
      index: index,
    );
  }
}

class _SearchableServiceDropdown extends StatefulWidget {
  final int index;

  const _SearchableServiceDropdown({
    required this.index,
  });

  @override
  State<_SearchableServiceDropdown> createState() => _SearchableServiceDropdownState();
}

class _SearchableServiceDropdownState extends State<_SearchableServiceDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  int? _lastServiceId;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
  }

  void _showOverlay(List<ServiceModel> filteredServices, BuildContext context) {
    _removeOverlay();
    
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Get cubit from the original context before creating overlay
    final cubit = context.read<NewReceiptVoucherCubit>();

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => Positioned(
        width: renderBox.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, -250 - 4),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filteredServices.length,
                itemBuilder: (overlayContext, index) {
                  final service = filteredServices[index];
                  return InkWell(
                    onTap: () {
                      if (widget.index < 0 || widget.index >= cubit.services.length) {
                        _removeOverlay();
                        return;
                      }

                      final existingService = cubit.services[widget.index];
                      cubit.updateService(
                        widget.index,
                        service.id,
                        service.name,
                        existingService.adultNumber,
                        existingService.childNumber,
                        existingService.kidNumber,
                        existingService.adultPrice,
                        existingService.childPrice,
                        existingService.kidPrice,
                      );
                      setState(() {
                        _lastServiceId = service.id;
                        _searchController.text = service.name;
                        _searchController.selection = TextSelection.fromPosition(
                          TextPosition(offset: service.name.length),
                        );
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _searchController.text = service.name;
                          });
                        }
                      });
                      _focusNode.unfocus();
                      _removeOverlay();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isDropdownOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        final cubit = context.read<NewReceiptVoucherCubit>();
        if (widget.index < 0 || widget.index >= cubit.services.length) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(),
          );
        }

        final service = cubit.services[widget.index];
        ServiceModel? selectedService;

        // Update text field when service changes
        if (service.serviceId != _lastServiceId) {
          _lastServiceId = service.serviceId;
          if (service.serviceId > 0 && cubit.servicesList.isNotEmpty) {
            try {
              selectedService = cubit.servicesList.firstWhere(
                (s) => s.id == service.serviceId,
              );
              if (_searchController.text != selectedService.name) {
                _searchController.text = selectedService.name;
                _searchController.selection = TextSelection.fromPosition(
                  TextPosition(offset: selectedService.name.length),
                );
              }
            } catch (e) {
              selectedService = null;
              if (_searchController.text.isNotEmpty) {
                _searchController.clear();
              }
            }
          } else if (service.serviceId == 0 && _searchController.text.isNotEmpty) {
            _searchController.clear();
          }
        } else if (service.serviceId > 0 && cubit.servicesList.isNotEmpty) {
          try {
            selectedService = cubit.servicesList.firstWhere(
              (s) => s.id == service.serviceId,
            );
          } catch (e) {
            selectedService = null;
          }
        }

        final availableServices = cubit.servicesList
            .where(
              (s) => !cubit.services.any(
                (sv) =>
                    sv.serviceId == s.id &&
                    sv.serviceId > 0 &&
                    cubit.services.indexOf(sv) != widget.index,
              ),
            )
            .toList();

        final filteredServices = _searchController.text.isEmpty
            ? availableServices
            : availableServices.where((s) {
                final searchText = _searchController.text.trim().toLowerCase();
                if (searchText.isEmpty) return true;
                final serviceName = s.name.toLowerCase();
                return serviceName.contains(searchText);
              }).toList();

        // Show dropdown when field gains focus
        if (_focusNode.hasFocus && !_isDropdownOpen && filteredServices.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _focusNode.hasFocus) {
              _showOverlay(filteredServices, context);
            }
          });
        }

        // Hide dropdown when field loses focus
        if (!_focusNode.hasFocus && _isDropdownOpen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _removeOverlay();
            }
          });
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: CompositedTransformTarget(
              link: _layerLink,
              child: TextFormField(
                key: ValueKey('service_field_${widget.index}_${service.serviceId}_${_lastServiceId}'),
                controller: _searchController,
                focusNode: _focusNode,
                readOnly: false,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  filled: false,
                  hintText: 'receipt_voucher.select_service'.tr(),
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColor.GRAY_HULF,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColor.GRAY_D8D8D8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColor.GRAY_D8D8D8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColor.YELLOW, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  suffixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: AppColor.GRAY_HULF,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    // Trigger rebuild to recalculate filteredServices
                  });
                  if (_isDropdownOpen) {
                    _removeOverlay();
                  }
                  final cubit = context.read<NewReceiptVoucherCubit>();
                  final availableServices = cubit.servicesList
                      .where(
                        (s) => !cubit.services.any(
                          (sv) =>
                              sv.serviceId == s.id &&
                              sv.serviceId > 0 &&
                              cubit.services.indexOf(sv) != widget.index,
                        ),
                      )
                      .toList();
                  
                  final currentFiltered = value.isEmpty
                      ? availableServices
                      : availableServices.where((s) {
                          final searchText = value.trim().toLowerCase();
                          if (searchText.isEmpty) return true;
                          final serviceName = s.name.toLowerCase();
                          return serviceName.contains(searchText);
                        }).toList();
                  
                  if (value.isNotEmpty && currentFiltered.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _showOverlay(currentFiltered, context);
                      }
                    });
                  }
                },
                onTap: () {
                  // Always show all available services when tapping the field, regardless of current text
                  final cubit = context.read<NewReceiptVoucherCubit>();
                  final availableServices = cubit.servicesList
                      .where(
                        (s) => !cubit.services.any(
                          (sv) =>
                              sv.serviceId == s.id &&
                              sv.serviceId > 0 &&
                              cubit.services.indexOf(sv) != widget.index,
                        ),
                      )
                      .toList();
                  
                  // Show all available services when tapping, not filtered by current text
                  if (availableServices.isNotEmpty) {
                    if (_isDropdownOpen) {
                      // If already open, close it
                      _removeOverlay();
                    } else {
                      // Open dropdown with all available services
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _showOverlay(availableServices, context);
                        }
                      });
                    }
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NumberInputField extends StatefulWidget {
  final int index;
  final String type;

  const _NumberInputField({
    required this.index,
    required this.type,
  });

  @override
  State<_NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<_NumberInputField> {
  late TextEditingController _controller;
  bool _isInitialized = false;
  int _lastNumber = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        final cubit = context.read<NewReceiptVoucherCubit>();
        if (widget.index < 0 || widget.index >= cubit.services.length) {
          return const Padding(padding: EdgeInsets.all(8.0), child: SizedBox());
        }
        
        final service = cubit.services[widget.index];
        final number = widget.type == 'adult' 
            ? service.adultNumber 
            : (widget.type == 'child' ? service.childNumber : service.kidNumber);
        
        // Only update controller if number changed externally (not from user input)
        if (!_isInitialized || (_lastNumber != number && _controller.text != number.toString())) {
          _isInitialized = true;
          _lastNumber = number;
          if (_controller.text != number.toString()) {
            final selection = _controller.selection;
            _controller.text = number.toString();
            if (selection.isValid && selection.baseOffset <= number.toString().length) {
              _controller.selection = selection;
            }
          }
        }
        
        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final isSmall = constraints.maxWidth < 70;
            final isLargeDesktop = constraints.maxWidth > 1200;
            final padding = isSmall ? 2.0 : 4.0;
            final iconSize = isSmall ? 14.0 : (isMobile ? 16.0 : (isLargeDesktop ? 20.0 : 18.0));
            final buttonSize = isSmall ? 16.0 : (isMobile ? 18.0 : (isLargeDesktop ? 22.0 : 20.0));
            
            return Padding(
              padding: EdgeInsets.all(padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: iconSize),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: buttonSize,
                      minHeight: buttonSize,
                      maxWidth: buttonSize + 2,
                      maxHeight: buttonSize + 2,
                    ),
                    onPressed: () {
                      final newNumber = (number > 0) ? number - 1 : 0;
                      final adultNumber = widget.type == 'adult' ? newNumber : service.adultNumber;
                      final childNumber = widget.type == 'child' ? newNumber : service.childNumber;
                      final kidNumber = widget.type == 'kid' ? newNumber : service.kidNumber;
                      cubit.updateServiceNumbers(widget.index, adultNumber, childNumber, kidNumber);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        final newNumber = value.isEmpty ? 0 : (int.tryParse(value) ?? 0);
                        final adultNumber = widget.type == 'adult' ? newNumber : service.adultNumber;
                        final childNumber = widget.type == 'child' ? newNumber : service.childNumber;
                        final kidNumber = widget.type == 'kid' ? newNumber : service.kidNumber;
                        _lastNumber = newNumber;
                        cubit.updateServiceNumbers(widget.index, adultNumber, childNumber, kidNumber);
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isSmall ? 4 : (isLargeDesktop ? 10 : 8),
                          horizontal: isSmall ? 2 : (isLargeDesktop ? 6 : 4),
                        ),
                      ),
                      style: TextStyle(fontSize: isSmall ? 11 : (isLargeDesktop ? 16 : 14)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: iconSize),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: buttonSize,
                      minHeight: buttonSize,
                      maxWidth: buttonSize + 2,
                      maxHeight: buttonSize + 2,
                    ),
                    onPressed: () {
                      final newNumber = number + 1;
                      final adultNumber = widget.type == 'adult' ? newNumber : service.adultNumber;
                      final childNumber = widget.type == 'child' ? newNumber : service.childNumber;
                      final kidNumber = widget.type == 'kid' ? newNumber : service.kidNumber;
                      cubit.updateServiceNumbers(widget.index, adultNumber, childNumber, kidNumber);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PriceInputField extends StatefulWidget {
  final int index;
  final String type;

  const _PriceInputField({
    required this.index,
    required this.type,
  });

  @override
  State<_PriceInputField> createState() => _PriceInputFieldState();
}

class _PriceInputFieldState extends State<_PriceInputField> {
  late TextEditingController _controller;
  bool _isInitialized = false;
  double _lastPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        final cubit = context.read<NewReceiptVoucherCubit>();
        if (widget.index < 0 || widget.index >= cubit.services.length) {
          return const Padding(padding: EdgeInsets.all(8.0), child: SizedBox());
        }
        
        final service = cubit.services[widget.index];
        final price = widget.type == 'adult' 
            ? service.adultPrice 
            : (widget.type == 'child' ? service.childPrice : service.kidPrice);
        
        // Only update controller if price changed externally (not from user input)
        if (!_isInitialized || (_lastPrice != price && !_controller.text.isEmpty && double.tryParse(_controller.text) != price)) {
          _isInitialized = true;
          _lastPrice = price;
          final displayText = price > 0 ? price.toStringAsFixed(2) : '';
          if (_controller.text != displayText) {
            final selection = _controller.selection;
            _controller.text = displayText;
            if (selection.isValid && selection.baseOffset <= displayText.length) {
              _controller.selection = selection;
            }
          }
        }
        
        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 70;
            final padding = isSmall ? 2.0 : 4.0;
            
            return Padding(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  onChanged: (value) {  
                    final newPrice = value.isEmpty ? 0.0 : (double.tryParse(value) ?? 0.0);
                    final service = cubit.services[widget.index];
                    final adultPrice = widget.type == 'adult' ? newPrice : service.adultPrice;
                    final childPrice = widget.type == 'child' ? newPrice : service.childPrice;
                    final kidPrice = widget.type == 'kid' ? newPrice : service.kidPrice;
                    _lastPrice = newPrice;
                    cubit.updateServicePrice(widget.index, adultPrice, childPrice, kidPrice);
                  }, 
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),  
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: isSmall ? 4 : 8,
                      horizontal: isSmall ? 2 : 4,
                    ),
                  ),
                  style: TextStyle(fontSize: isSmall ? 11 : 14), 
                ),
              ), 
            );
          }, 
        );
      }, 
    );
  } 
}
  
