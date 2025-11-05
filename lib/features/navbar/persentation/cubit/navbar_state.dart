part of 'navbar_cubit.dart';

abstract class NavbarState extends Equatable {
  const NavbarState();

  @override
  List<Object?> get props => [];
}

class NavbarInitial extends NavbarState {}

class NavbarLoading extends NavbarState {}

class NavbarSuccess extends NavbarState {
  // TODO: Add success data here
  const NavbarSuccess();
}

class NavbarError extends NavbarState {
  final String message;

  const NavbarError(this.message);

  @override
  List<Object?> get props => [message];
}
