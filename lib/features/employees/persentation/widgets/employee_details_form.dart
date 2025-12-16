import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_form_fields.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_form_date_fields.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_form_special_fields.dart';

class EmployeeDetailsForm extends StatefulWidget {
  const EmployeeDetailsForm({super.key});

  @override
  State<EmployeeDetailsForm> createState() => _EmployeeDetailsFormState();
}

class _EmployeeDetailsFormState extends State<EmployeeDetailsForm> {
  bool _obscurePassword = true;
  bool _isCustomPosition = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewEmployeeCubit, NewEmployeeState>(
      buildWhen: (previous, current) {
        // Always rebuild on NewEmployeeFormUpdated to ensure state is synced
        return current is NewEmployeeFormUpdated || current is NewEmployeeInitial;
      },
      builder: (context, state) {
        final cubit = context.read<NewEmployeeCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'employees.employee_details'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            EmployeeFormFields.buildImageField(context, cubit),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EmployeeFormFields.buildTextField(
                        label: 'employees.name_employee'.tr() + ' *',
                        value: cubit.name,
                        onChanged: cubit.updateName,
                      ),
                      const SizedBox(height: 16),
                      EmployeeFormFields.buildTextField(
                        label: 'employees.phone_number_optional'.tr(),
                        value: cubit.phoneNumber ?? '',
                        onChanged: cubit.updatePhoneNumber,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildPositionDropdown(context, cubit),
                      const SizedBox(height: 16),
                      _buildSalaryTypeDropdown(context, cubit),
                      const SizedBox(height: 16),
                      if (cubit.isCommission) EmployeeFormSpecialFields.buildCommissionField(context, cubit),
                      if (cubit.isSalary) _buildSalaryField(context, cubit),
                      const SizedBox(height: 16),
                      _buildIsEmaratDropdown(context, cubit),
                      if (!cubit.isEmarat) ...[
                        const SizedBox(height: 16),
                        EmployeeFormSpecialFields.buildVisaCostField(context, cubit),
                        const SizedBox(height: 16),
                        EmployeeFormDateFields.buildDateField(
                          context,
                          cubit,
                          'employees.start_date'.tr() + ' *',
                          () => cubit.startVisa,
                          cubit.updateStartVisa,
                        ),
                        const SizedBox(height: 16),
                        EmployeeFormDateFields.buildDateField(
                          context,
                          cubit,
                          'employees.end_date'.tr() + ' *',
                          () => cubit.endVisa,
                          cubit.updateEndVisa,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildControlSystemDropdown(context, cubit),
                      if (cubit.controlSystem) ...[
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        EmployeeFormFields.buildTextField(
                          label: 'employees.email'.tr() + ' *',
                          value: cubit.email,
                          onChanged: cubit.updateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        EmployeeFormFields.buildTextField(
                          label: 'employees.password'.tr() + ' *',
                          value: cubit.password,
                          onChanged: cubit.updatePassword,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: AppColor.GRAY_D8D8D8,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  Widget _buildPositionDropdown(BuildContext context, NewEmployeeCubit cubit) {
    final positions = [
      'employees.position_owner'.tr(),
      'employees.position_operation_manager'.tr(),
      'employees.position_desk_agent'.tr(),
      'employees.position_camp_agent'.tr(),
      'employees.position_operation_assistant'.tr(),
      'employees.position_custom'.tr(),
    ];
    final positionKeys = ['Owner', 'Operation Manager', 'Desk Agent', 'Camp Agent', 'Operation Assistant', 'Custom'];
    
    // Check if current position is custom (not in the list)
    final isCurrentCustom = cubit.position != null && 
        !positionKeys.take(5).contains(cubit.position);
    
    if (_isCustomPosition || isCurrentCustom) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'employees.position'.tr() + ' *',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: EmployeeFormFields.buildTextField(
                  label: '',
                  value: cubit.position ?? '',
                  onChanged: (value) {
                    cubit.updatePosition(value.isEmpty ? null : value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isCustomPosition = false;
                  });
                  cubit.updatePosition(null);
                },
                child: Text('common.select'.tr()),
              ),
            ],
          ),
        ],
      );
    }
    
    return EmployeeFormFields.buildDropdown<String>(
      label: 'employees.position'.tr() + ' *',
      value: cubit.position,
      items: positionKeys,
      onChanged: (value) {
        if (value == 'Custom') {
          setState(() {
            _isCustomPosition = true;
          });
          cubit.updatePosition(null);
        } else {
          cubit.updatePosition(value);
        }
      },
      displayText: (p) {
        final index = positionKeys.indexOf(p);
        return index >= 0 ? positions[index] : p;
      },
    );
  }

  Widget _buildSalaryTypeDropdown(BuildContext context, NewEmployeeCubit cubit) {
    final types = [
      'employees.salary_type_salary'.tr(),
      'employees.salary_type_commission'.tr(),
      'employees.salary_type_salary_and_commission'.tr(),
    ];
    final typeKeys = ['Salary', 'Commission', 'Salary and Commission'];
    
    String? currentValue;
    if (cubit.isSalary && cubit.isCommission) {
      currentValue = 'Salary and Commission';
    } else if (cubit.isSalary) {
      currentValue = 'Salary';
    } else if (cubit.isCommission) {
      currentValue = 'Commission';
    }
    
    return EmployeeFormFields.buildDropdown<String>(
      label: 'employees.sallery'.tr() + ' *',
      value: currentValue,
      items: typeKeys,
      onChanged: (value) {
        if (value == 'Salary') {
          cubit.updateSalaryType(true, false);
        } else if (value == 'Commission') {
          cubit.updateSalaryType(false, true);
        } else if (value == 'Salary and Commission') {
          cubit.updateSalaryType(true, true);
        }
      },
      displayText: (t) {
        final index = typeKeys.indexOf(t);
        return index >= 0 ? types[index] : t;
      },
    );
  }


  Widget _buildSalaryField(BuildContext context, NewEmployeeCubit cubit) {
    return EmployeeFormFields.buildTextField(
      label: 'employees.sallery'.tr() + ' *',
      value: cubit.salary?.toString() ?? '',
      onChanged: (value) => cubit.updateSalary(double.tryParse(value)),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildIsEmaratDropdown(BuildContext context, NewEmployeeCubit cubit) {
    return EmployeeFormFields.buildDropdown<bool>(
      label: 'employees.is_employee_emirati'.tr() + ' *',
      value: cubit.isEmarat,
      items: [true, false],
      onChanged: (value) => cubit.updateIsEmarat(value ?? false),
      displayText: (v) => v ? 'employees.yes'.tr() : 'employees.no'.tr(),
    );
  }


  Widget _buildControlSystemDropdown(BuildContext context, NewEmployeeCubit cubit) {
    return EmployeeFormFields.buildDropdown<bool>(
      label: 'employees.control_system'.tr() + ' *',
      value: cubit.controlSystem,
      items: [true, false],
      onChanged: (value) => cubit.updateControlSystem(value ?? true),
      displayText: (v) => v ? 'employees.yes'.tr() : 'employees.no'.tr(),
    );
  }

}

