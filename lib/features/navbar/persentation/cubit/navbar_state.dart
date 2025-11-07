part of 'navbar_cubit.dart';

class NavbarState extends Equatable {
  const NavbarState({required this.selectedSection});

  factory NavbarState.initial(NavbarSection section) =>
      NavbarState(selectedSection: section);

  final NavbarSection selectedSection;

  NavbarState copyWith({NavbarSection? selectedSection}) {
    return NavbarState(
      selectedSection: selectedSection ?? this.selectedSection,
    );
  }

  @override
  List<Object?> get props => [selectedSection];
}
