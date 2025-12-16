import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';

class SearchableHotelCell extends StatefulWidget {
  final String? value;
  final List<HotelModel> hotels;
  final ValueChanged<String?> onChanged;
  final String? hint;

  const SearchableHotelCell({
    super.key,
    this.value,
    required this.hotels,
    required this.onChanged,
    this.hint,
  });

  @override
  State<SearchableHotelCell> createState() => _SearchableHotelCellState();
}

class _SearchableHotelCellState extends State<SearchableHotelCell> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  List<HotelModel> _filteredHotels = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? '';
    _filteredHotels = widget.hotels;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(SearchableHotelCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
    if (widget.hotels != oldWidget.hotels) {
      _filterHotels(_controller.text);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _filterHotels(_controller.text);
      if (_filteredHotels.isNotEmpty && !_isDropdownOpen) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _focusNode.hasFocus) {
            _showOverlay();
          }
        });
      }
    } else {
      _removeOverlay();
    }
  }

  void _filterHotels(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHotels = widget.hotels;
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredHotels = widget.hotels
            .where((hotel) => hotel.name.toLowerCase().contains(lowerQuery))
            .toList();
      }
    });
  }

  void _showOverlay() {
    _removeOverlay();
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: renderBox.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, renderBox.size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: _filteredHotels.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('common.no_results'.tr()),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _filteredHotels.length,
                      itemBuilder: (context, index) {
                        final hotel = _filteredHotels[index];
                        return InkWell(
                          onTap: () {
                            _controller.text = hotel.name;
                            widget.onChanged(hotel.name);
                            _focusNode.unfocus();
                            _removeOverlay();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Text(
                              hotel.name,
                              style: const TextStyle(fontSize: 14),
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

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textDirection: ui.TextDirection.ltr,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: widget.hint?.tr() ?? 'booking.hotel_name'.tr(),
            suffixIcon: const Icon(Icons.arrow_drop_down, size: 20, color: AppColor.GRAY_HULF),
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          onChanged: (value) {
            _filterHotels(value);
            widget.onChanged(value.isEmpty ? null : value);
            if (value.isNotEmpty && _filteredHotels.isNotEmpty && !_isDropdownOpen) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _showOverlay();
                }
              });
            } else if (value.isEmpty) {
              _removeOverlay();
            }
          },
          onTap: () {
            if (_filteredHotels.isNotEmpty && !_isDropdownOpen) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _showOverlay();
                }
              });
            }
          },
        ),
      ),
    );
  }
}

