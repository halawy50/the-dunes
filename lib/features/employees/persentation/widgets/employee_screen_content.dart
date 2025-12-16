import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_content_builder.dart';

class EmployeeScreenContent extends StatefulWidget {
  const EmployeeScreenContent({super.key});

  @override
  State<EmployeeScreenContent> createState() => _EmployeeScreenContentState();
}

class _EmployeeScreenContentState extends State<EmployeeScreenContent> {
  final ScrollController _scrollController = ScrollController();
  int _previousPage = 1;
  String _searchQuery = '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        final cubit = context.read<EmployeeCubit>();
        final currentPage = cubit.currentPage;

        if (currentPage != _previousPage) {
          _previousPage = currentPage;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients && mounted) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }

        if (state is EmployeeSuccess) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.success,
          );
        } else if (state is EmployeeError) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.error,
          );
        }
      },
      child: EmployeeContentBuilder(
        scrollController: _scrollController,
        searchQuery: _searchQuery,
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
      ),
    );
  }
}
