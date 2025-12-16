import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';

class EmployeeFormFields {
  static Widget buildTextField({
    required String label,
    required String value,
    required void Function(String) onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? suffixText,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixText: suffixText,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) displayText,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            suffixText: suffixText,
          ),
        ),
      ],
    );
  }

  static Widget buildImageField(
    BuildContext context,
    NewEmployeeCubit cubit,
  ) {
    return BlocBuilder<NewEmployeeCubit, NewEmployeeState>(
      builder: (context, state) {
        final currentCubit = context.read<NewEmployeeCubit>();
        final hasImage = currentCubit.imagePath != null || 
                        (currentCubit.imageBytes != null && currentCubit.imageBytes!.isNotEmpty);
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'employees.image_optional'.tr(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickImage(context, currentCubit),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColor.GRAY_WHITE,
                child: hasImage
                    ? ClipOval(
                        child: _buildImagePreview(currentCubit),
                      )
                    : const Icon(Icons.person, size: 40),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _pickImage(context, currentCubit),
              child: Text('employees.add_image'.tr()),
            ),
            if (hasImage)
              TextButton(
                onPressed: () {
                  currentCubit.clearImage();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('common.delete'.tr()),
              ),
          ],
        );
      },
    );
  }

  static Widget _buildImagePreview(NewEmployeeCubit cubit) {
    try {
      if (cubit.imageBytes != null && cubit.imageBytes!.isNotEmpty) {
        // For web, use bytes to display image
        return Image.memory(
          cubit.imageBytes!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.person, size: 40),
        );
      }
      return const Icon(Icons.person, size: 40);
    } catch (e) {
      return const Icon(Icons.person, size: 40);
    }
  }

  static Future<void> _pickImage(
    BuildContext context,
    NewEmployeeCubit cubit,
  ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        
        if (file.bytes != null && file.bytes!.isNotEmpty) {
          cubit.updateImageFile(file.name, file.bytes!);
        }
      }
    } catch (e) {
      // Silently handle errors - user may have cancelled or there was a minor issue
      // Only show error for critical failures
      debugPrint('Image picker error: $e');
    }
  }
}

