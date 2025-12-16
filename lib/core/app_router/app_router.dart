import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/app_router/app_router_error_builder.dart';
import 'package:the_dunes/core/app_router/app_router_redirect.dart';
import 'package:the_dunes/core/app_router/app_router_routes.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/login/data/models/permissions_model.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/analysis';
  static final GlobalKey<NavigatorState> navbarKey = GlobalKey<NavigatorState>();

  static String getFirstAllowedRoute(PermissionsModel? permissions) {
    if (permissions == null) return home;
    
    // Priority order for first page
    final preferredSections = [
      NavbarSection.receiptVoucher,
      NavbarSection.bookings,
      NavbarSection.pickupTime,
      NavbarSection.services,
      NavbarSection.hotels,
      NavbarSection.camp,
      NavbarSection.analysis,
      NavbarSection.employees,
    ];
    
    // Find first allowed section
    for (final section in preferredSections) {
      if (section.isAllowed(permissions)) {
        return section.route;
      }
    }
    
    // Fallback to home if no section is allowed
    return home;
  }

  static NavbarSection? getSectionFromPath(String path) {
    if (path.startsWith('/booking')) {
      return NavbarSection.bookings;
    }
    if (path.startsWith('/receipt_voucher')) {
      return NavbarSection.receiptVoucher;
    }
    if (path.startsWith('/employees')) {
      return NavbarSection.employees;
    }
    if (path.startsWith('/agents')) {
      return NavbarSection.agents;
    }
    switch (path) {
      case '/analysis':
        return NavbarSection.analysis;
      case '/pickup_time':
        return NavbarSection.pickupTime;
      case '/services':
        return NavbarSection.services;
      case '/hotels':
        return NavbarSection.hotels;
      case '/operations':
        return NavbarSection.operations;
      case '/camp':
        return NavbarSection.camp;
      case '/history':
        return NavbarSection.history;
      case '/setting':
        return NavbarSection.settings;
      default:
        return null;
    }
  }

  static final GoRouter router = GoRouter(
    initialLocation: login,
    redirect: AppRouterRedirect.redirect,
    routes: AppRouterRoutes.getRoutes(),
    errorBuilder: AppRouterErrorBuilder.buildError,
  );
}
