import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/navbar_content.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({
    super.key,
    required this.initialSection,
    this.navigationShell,
  });

  final NavbarSection initialSection;
  final StatefulNavigationShell? navigationShell;

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen>
    with AutomaticKeepAliveClientMixin {
  late final NavbarCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = di<NavbarCubit>()..init(widget.initialSection);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _cubit,
      child: NavbarContent(
        initialSection: widget.initialSection,
        navigationShell: widget.navigationShell,
      ),
    );
  }
}
