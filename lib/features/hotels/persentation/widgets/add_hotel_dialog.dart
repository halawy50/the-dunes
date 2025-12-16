import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/hotels/persentation/cubit/hotel_cubit.dart';

class AddHotelDialog extends StatefulWidget {
  const AddHotelDialog({super.key});

  @override
  State<AddHotelDialog> createState() => _AddHotelDialogState();
}

class _AddHotelDialogState extends State<AddHotelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<HotelCubit>();
      cubit.createHotel(_nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HotelCubit, HotelState>(
      listener: (context, state) {
        if (state is HotelSuccess) {
          Navigator.of(context).pop();
        } else if (state is HotelError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        title: Text('hotels.add_new'.tr()),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'hotels.name'.tr(),
              hintText: 'hotels.name_hint'.tr(),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'hotels.name_required'.tr();
              }
              return null;
            },
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.cancel'.tr()),
          ),
          BlocBuilder<HotelCubit, HotelState>(
            builder: (context, state) {
              final isLoading = state is HotelLoading;
              return ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.YELLOW,
                  foregroundColor: AppColor.WHITE,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                        ),
                      )
                    : Text('common.save'.tr()),
              );
            },
          ),
        ],
      ),
    );
  }
}


