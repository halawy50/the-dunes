import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_filter_helper.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_content_body.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_scroll_handler.dart';

class EmployeeContentBuilder extends StatefulWidget {
  const EmployeeContentBuilder({
    super.key,
    required this.scrollController,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  final ScrollController scrollController;
  final String searchQuery;
  final void Function(String) onSearchChanged;

  @override
  State<EmployeeContentBuilder> createState() => _EmployeeContentBuilderState();
}

class _EmployeeContentBuilderState extends State<EmployeeContentBuilder> {
  final ScrollController _horizontalScrollController = ScrollController();
  int _previousPage = 1;
  double _dragStartPosition = 0.0;
  double _dragStartScrollPosition = 0.0;

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _handleDragStart(double position, double scrollPosition) {
    _dragStartPosition = position;
    _dragStartScrollPosition = scrollPosition;
  }

  void _handleDragUpdate(double localPosition) {
    EmployeeScrollHandler.handleDragUpdate(
      _horizontalScrollController,
      localPosition,
      _dragStartPosition,
      _dragStartScrollPosition,
    );
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
            if (widget.scrollController.hasClients && mounted) {
              widget.scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
      child: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          final cubit = context.read<EmployeeCubit>();
          final employees = state is EmployeeLoaded ? state.employees : <EmployeeEntity>[];
          final filteredEmployees = EmployeeFilterHelper.filterEmployees(employees, widget.searchQuery);
          final currentPage = cubit.currentPage;
          final totalPages = cubit.totalPages;

          return SingleChildScrollView(
            controller: widget.scrollController,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: EmployeeContentBody(
              filteredEmployees: filteredEmployees,
              state: state,
              currentPage: currentPage,
              totalPages: totalPages,
              horizontalScrollController: _horizontalScrollController,
              onDragStart: _handleDragStart,
              onDragUpdate: _handleDragUpdate,
              onSearchChanged: widget.onSearchChanged,
            ),
          );
        },
      ),
    );
  }
}

