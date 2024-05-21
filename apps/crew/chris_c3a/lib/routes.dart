import 'package:chris_c3a/views/todos/todos_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helpers/services/auth_services.dart';
import 'views/about/about_page.dart';
import 'views/auth/locked.dart';
import 'views/auth/login.dart';
import 'views/error_pages/error_404.dart';
import 'views/home/home_page.dart';
import 'views/me/edit_user_profile.dart';

// class AuthMiddleware extends GetMiddleware {
//   final AuthService _authService = Get.find<AuthService>();

//   late final Map<RegExp, List<String>> rolesRequiredByRoutePattern;

//   AuthMiddleware() {
//     rolesRequiredByRoutePattern = {
//       routeAllowedByRoles('/admin/**'): [
//         'admin',
//       ], // Matches any route starting with '/admin/'
//       routeAllowedByRoles('/development/**'): [
//         'admin',
//         'developer',
//       ], // Matches any route starting with '/development/'
//     };
//   }

//   RegExp routeAllowedByRoles(String pattern) {
//     // Convert wildcard pattern to a regular expression.
//     // E.g., 'admin/**' becomes '^admin/.*$'
//     String regexString = pattern
//         .replaceAll('.', '\\.') // Escape dots
//         .replaceAll(
//           '**',
//           '.*',
//         ) // Convert '**' to '.*' (zero or more of any character)
//         .replaceAll(
//           '*',
//           '[^/]*',
//         ); // Convert '*' to '[^/]*' (zero or more of not a slash)
//     return RegExp('^$regexString\$');
//   }

//   @override
//   RouteSettings? redirect(String? route) {
//     if (!_authService.isLoggedIn) {
//       return const RouteSettings(name: '/auth/login');
//     } else if (route != null) {
//       for (var entry in rolesRequiredByRoutePattern.entries) {
//         if (entry.key.hasMatch(route)) {
//           if (!_hasAtLeastRequiredRole(entry.value)) {
//             // return const RouteSettings(name: '/unauthorized');
//             return const RouteSettings(name: '/dashboard');
//           }
//           break; // Match found and authorized, no need to check further
//         }
//       }
//     }
//     return null; // No redirection needed, user has access or no role restriction on the route
//   }

//   bool _hasAtLeastRequiredRole(List<String> requiredRoles) {
//     for (var role in requiredRoles) {
//       print('checking role: $role');
//       if (_authService.hasRole(role)) {
//         return true; // User has at least one of the required roles
//       }
//     }
//     return false; // User does not have any of the required roles
//   }
// }

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = Get.find<AuthService>();

  @override
  RouteSettings? redirect(String? route) {
    // print('Redirecting to $route');

    if (route == '/auth/login') {
      return null;
    }
    // Use reactive state management to determine if the user is logged in
    if (_authService.isLoggedIn) {
      // print('User is logged in');
      return null; // No redirection needed, user is logged in
    } else {
      // Redirect to login page if not logged in
      // print('User is not logged in');
      return const RouteSettings(name: '/auth/login');
    }
  }
}

getPageRoute() {
  var routes = [
    GetPage(
      name: '/unauthorized',
      page: () => const LockedPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/',
      page: () => const HomePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/error-404',
      page: () => const Error404(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/auth/login',
      page: () => const LoginPage(),
    ),
    GetPage(
      name: '/my-profile',
      page: () => const EditUserProfile(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/about',
      page: () => const AboutPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/todos',
      page: () => const TodosPage(),
      middlewares: [AuthMiddleware()],
    ),
  ];
  return routes
      .map(
        (e) => GetPage(
          name: e.name,
          page: e.page,
          middlewares: e.middlewares,
          transition: Transition.noTransition,
        ),
      )
      .toList();
}
