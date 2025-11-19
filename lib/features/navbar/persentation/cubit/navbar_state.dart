part of 'navbar_cubit.dart';

class NavbarState extends Equatable {
  const NavbarState({
    required this.selectedSection,
    this.isSidebarVisible = true,
  });

  factory NavbarState.initial(NavbarSection section) =>
      NavbarState(selectedSection: section, isSidebarVisible: true);

  final NavbarSection selectedSection;
  final bool isSidebarVisible;

  NavbarState copyWith({
    NavbarSection? selectedSection,
    bool? isSidebarVisible,
  }) {
    return NavbarState(
      selectedSection: selectedSection ?? this.selectedSection,
      isSidebarVisible: isSidebarVisible ?? this.isSidebarVisible,
    );
  }

  @override
  List<Object?> get props => [selectedSection, isSidebarVisible];
}
