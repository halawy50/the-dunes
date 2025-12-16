import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class EditableHotelDropdownContent extends StatefulWidget {
  final String? label;
  final bool isRequired;
  final TextEditingController controller;
  final FocusNode focusNode;
  final LayerLink layerLink;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;

  const EditableHotelDropdownContent({
    super.key,
    this.label,
    required this.isRequired,
    required this.controller,
    required this.focusNode,
    required this.layerLink,
    required this.onChanged,
    required this.onTap,
  });

  @override
  State<EditableHotelDropdownContent> createState() =>
      _EditableHotelDropdownContentState();
}

class _EditableHotelDropdownContentState
    extends State<EditableHotelDropdownContent> {
  bool _isManualInput = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label! + (widget.isRequired ? ' *' : ''),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isManualInput = !_isManualInput;
                  });
                },
                icon: Icon(
                  _isManualInput ? Icons.list : Icons.edit,
                  size: 16,
                  color: AppColor.YELLOW,
                ),
                label: Text(
                  _isManualInput
                      ? 'common.select_from_list'.tr()
                      : 'common.manual_input'.tr(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.YELLOW,
                  ),
                ),
              ),
            ],
          ),
        if (widget.label != null) const SizedBox(height: 8),
        CompositedTransformTarget(
          link: widget.layerLink,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              hintText: widget.label ?? 'booking.hotel_name'.tr(),
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.GRAY_D8D8D8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.YELLOW, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onChanged('');
                      },
                    )
                  : _isManualInput
                      ? const Icon(
                          Icons.edit,
                          color: AppColor.GRAY_HULF,
                          size: 20,
                        )
                      : const Icon(
                          Icons.arrow_drop_down,
                          color: AppColor.GRAY_HULF,
                          size: 20,
                        ),
            ),
            onChanged: widget.onChanged,
            onTap: _isManualInput ? null : widget.onTap,
          ),
        ),
      ],
    );
  }
}

