import 'package:captainapp_crew_dashboard/views/admin/users/create_user.dart';
import 'package:captainapp_crew_dashboard/views/admin/users/user_list.dart';
import 'package:captainapp_crew_dashboard/views/apps/CRM/contacts_page.dart';
import 'package:captainapp_crew_dashboard/views/apps/CRM/opportunities.dart';
import 'package:captainapp_crew_dashboard/views/apps/assets/add_product.dart';
import 'package:captainapp_crew_dashboard/views/apps/assets/customers.dart';
import 'package:captainapp_crew_dashboard/views/apps/assets/invoice_page.dart';
import 'package:captainapp_crew_dashboard/views/apps/assets/product_detail.dart';
import 'package:captainapp_crew_dashboard/views/apps/assets/products.dart';
import 'package:captainapp_crew_dashboard/views/apps/calender.dart';
import 'package:captainapp_crew_dashboard/views/apps/chat_page.dart';
import 'package:captainapp_crew_dashboard/views/apps/contacts/edit_profile.dart';
import 'package:captainapp_crew_dashboard/views/apps/contacts/member_list.dart';
import 'package:captainapp_crew_dashboard/views/apps/entities/create_entity.dart';
import 'package:captainapp_crew_dashboard/views/apps/entities/entity_detail.dart';
import 'package:captainapp_crew_dashboard/views/apps/entities/entity_list.dart';
import 'package:captainapp_crew_dashboard/views/apps/file/file_manager.dart';
import 'package:captainapp_crew_dashboard/views/apps/file/file_uploader.dart';
import 'package:captainapp_crew_dashboard/views/apps/fitness/fitness_screen.dart';
import 'package:captainapp_crew_dashboard/views/apps/kanban_page.dart';
import 'package:captainapp_crew_dashboard/views/apps/mail_box_screen.dart';
import 'package:captainapp_crew_dashboard/views/apps/shopping_customer/shopping_customer_screen.dart';
import 'package:captainapp_crew_dashboard/views/auth/create_user.dart';
import 'package:captainapp_crew_dashboard/views/auth/forgot_password.dart';
import 'package:captainapp_crew_dashboard/views/auth/forgot_password_2.dart';
import 'package:captainapp_crew_dashboard/views/auth/locked.dart';
import 'package:captainapp_crew_dashboard/views/auth/login.dart';
import 'package:captainapp_crew_dashboard/views/auth/login_2.dart';
import 'package:captainapp_crew_dashboard/views/auth/register.dart';
import 'package:captainapp_crew_dashboard/views/auth/register_2.dart';
import 'package:captainapp_crew_dashboard/views/auth/reset_password.dart';
import 'package:captainapp_crew_dashboard/views/auth/reset_password_2.dart';
import 'package:captainapp_crew_dashboard/views/development/changelog.dart';
import 'package:captainapp_crew_dashboard/views/development/dev_cycle_page.dart';
import 'package:captainapp_crew_dashboard/views/development/dev_kanban_page.dart';
import 'package:captainapp_crew_dashboard/views/forms/basic_page.dart';
import 'package:captainapp_crew_dashboard/views/forms/form_mask.dart';
import 'package:captainapp_crew_dashboard/views/forms/quill_editor.dart';
import 'package:captainapp_crew_dashboard/views/forms/validation.dart';
import 'package:captainapp_crew_dashboard/views/forms/wizard.dart';
import 'package:captainapp_crew_dashboard/views/me/edit_user_profile.dart';
import 'package:captainapp_crew_dashboard/views/other/basic_table.dart';
import 'package:captainapp_crew_dashboard/views/other/fl_chart_screen.dart';
import 'package:captainapp_crew_dashboard/views/other/google_map.dart';
import 'package:captainapp_crew_dashboard/views/other/sfmap_page.dart';
import 'package:captainapp_crew_dashboard/views/other/synsfusion_chart.dart';
import 'package:captainapp_crew_dashboard/views/starter.dart';
import 'package:captainapp_crew_dashboard/views/ui/buttons_page.dart';
import 'package:captainapp_crew_dashboard/views/ui/cards_page.dart';
import 'package:captainapp_crew_dashboard/views/ui/carousels.dart';
import 'package:captainapp_crew_dashboard/views/ui/dialogs.dart';
import 'package:captainapp_crew_dashboard/views/ui/drag_drop.dart';
import 'package:captainapp_crew_dashboard/views/ui/notifications.dart';
import 'package:captainapp_crew_dashboard/views/ui/reviews_page.dart';
import 'package:captainapp_crew_dashboard/views/ui/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helpers/services/auth_services.dart';
import 'views/auth/locked_2.dart';
import 'views/dashboard.dart';
import 'views/error_pages/coming_soon_page.dart';
import 'views/error_pages/error_404.dart';
import 'views/error_pages/error_500.dart';
import 'views/error_pages/maintenance_page.dart';
import 'views/extra_pages/faqs_page.dart';
import 'views/extra_pages/pricing.dart';
import 'views/extra_pages/time_line_page.dart';
import 'views/ui/landing_page.dart';
import 'views/ui/nft_dashboard.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = Get.find<AuthService>();

  late final Map<RegExp, List<String>> rolesRequiredByRoutePattern;

  AuthMiddleware() {
    rolesRequiredByRoutePattern = {
      // routeAllowedByRoles('/admin/**'): [
      //   'admin',
      // ], // Matches any route starting with '/admin/'
      routeAllowedByRoles('/development/**'): [
        'admin',
        'developer',
      ], // Matches any route starting with '/development/'
    };
  }

  RegExp routeAllowedByRoles(String pattern) {
    // Convert wildcard pattern to a regular expression.
    // E.g., 'admin/**' becomes '^admin/.*$'
    String regexString = pattern
        .replaceAll('.', '\\.') // Escape dots
        .replaceAll(
          '**',
          '.*',
        ) // Convert '**' to '.*' (zero or more of any character)
        .replaceAll(
          '*',
          '[^/]*',
        ); // Convert '*' to '[^/]*' (zero or more of not a slash)
    return RegExp('^$regexString\$');
  }

  @override
  RouteSettings? redirect(String? route) {
    if (!_authService.isLoggedIn) {
      return const RouteSettings(name: '/auth/login');
    } else if (route != null) {
      for (var entry in rolesRequiredByRoutePattern.entries) {
        if (entry.key.hasMatch(route)) {
          if (!_hasAtLeastRequiredRole(entry.value)) {
            // return const RouteSettings(name: '/unauthorized');
            return const RouteSettings(name: '/dashboard');
          }
          break; // Match found and authorized, no need to check further
        }
      }
    }
    return null; // No redirection needed, user has access or no role restriction on the route
  }

  bool _hasAtLeastRequiredRole(List<String> requiredRoles) {
    for (var role in requiredRoles) {
      print('checking role: $role');
      if (_authService.hasRole(role)) {
        return true; // User has at least one of the required roles
      }
    }
    return false; // User does not have any of the required roles
  }
}

getPageRoute() {
  var routes = [
    GetPage(
      name: '/unauthorized',
      page: () => const LockedPage2(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/',
      page: () => const DashboardPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: '/faqs', page: () => const FaqsPage()),

    GetPage(
      name: '/pricing',
      page: () => const Pricing(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/starter',
      page: () => const Starter(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/dashboard',
      page: () => const DashboardPage(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- profile ---------------///
    GetPage(
      name: '/my-profile',
      page: () => const EditUserProfile(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- Admin ----------------///
    GetPage(
      name: '/admin/users',
      page: () => const UserList(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/admin/roles',
      page: () => const KanBanPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/admin/users/:userId',
      page: () => const UserList(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/admin/create-user',
      page: () => const CreateUser(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- development -----------///
    // GetPage(
    //   name: '/development/issues',
    //   page: () => const DevelopmentPage(),
    //   middlewares: [AuthMiddleware()],
    // ),
    GetPage(
      name: '/development/changelog',
      page: () => ChangelogScreen(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/development/kanban',
      page: () => DevKanBanPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/development/cycle',
      page: () => DevCyclePage(),
      middlewares: [AuthMiddleware()],
    ),

    ///------------- Vendor Pages -----------///
    GetPage(
      name: '/vendor/products',
      page: () => const FileManager(),
      middlewares: [AuthMiddleware()],
    ),

    ///--------------- assets ---------------///
    GetPage(
      name: '/assets/asset-list',
      page: () => const EntityListPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/apps/assets/products',
      page: () => const ProductPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/apps/assets/add_product',
      page: () => const AddProduct(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/apps/assets/product-detail',
      page: () => const ProductDetail(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/apps/assets/customers',
      page: () => const Customers(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/apps/assets/invoice',
      page: () => const InvoicePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/timeline',
      page: () => const TimeLinePage(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- File ----------------///

    GetPage(
      name: '/apps/files',
      page: () => const FileManager(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/apps/file-uploader',
      page: () => const FileUploader(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- Ntf ----------------///

    GetPage(
      name: '/NFTDashboard',
      page: () => const NFTDashboardScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/calender',
      page: () => const Calender(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/shopping-customer',
      page: () => const ShoppingCustomerScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/fitness',
      page: () => const FitnessScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/mila_box',
      page: () => const MailBoxScreen(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- KanBan ----------------///

    GetPage(
      name: '/kanban',
      page: () => const KanBanPage(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- entities ----------------///
    GetPage(
      name: '/entities/entity-list',
      page: () => const EntityListPage(),
      middlewares: [AuthMiddleware()],
    ),
    // GetPage(
    //   name: '/entities/entity-detail:entityId',
    //   page: () => const EntityDetail(),
    //   middlewares: [AuthMiddleware()],
    // ),
    GetPage(
      name: '/entities/create-entity',
      page: () => const CreateEntity(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/entities/:entityId',
      page: () => EntityDetail(),
      transition: Transition.noTransition,
    ),

    ///---------------- Contacts ----------------///

    GetPage(
      name: '/contacts/profile',
      page: () => const ProfilePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/contacts/members',
      page: () => const MemberList(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/contacts/edit-profile',
      page: () => const EditProfile(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- CRM ----------------///

    GetPage(
      name: '/crm/contacts',
      page: () => const ContactsPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/crm/opportunities',
      page: () => const OpportunitiesPage(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- Auth ----------------///

    GetPage(name: '/auth/login', page: () => const LoginPage()),
    GetPage(name: '/auth/login1', page: () => const Login2()),
    GetPage(name: '/auth/forgot_password', page: () => const ForgotPassword()),
    GetPage(
      name: '/auth/forgot_password1',
      page: () => const ForgotPassword2(),
    ),
    GetPage(name: '/auth/register', page: () => const Register()),
    GetPage(name: '/auth/register1', page: () => const Register2()),
    GetPage(name: '/auth/reset_password', page: () => const ResetPassword()),
    GetPage(name: '/auth/reset_password1', page: () => const ResetPassword2()),
    GetPage(
      name: '/auth/locked',
      page: () => const LockedPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/auth/locked1',
      page: () => const LockedPage2(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- UI ----------------///

    GetPage(
      name: '/ui/buttons',
      page: () => const ButtonsPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ui/cards',
      page: () => const CardsPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ui/tabs',
      page: () => const TabsPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ui/dialogs',
      page: () => const Dialogs(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ui/carousels',
      page: () => const Carousels(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ui/drag-drop',
      page: () => const DragDropPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ui/notification',
      page: () => const Notifications(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ui/reviews',
      page: () => const ReviewsPage(),
      middlewares: [AuthMiddleware()],
    ),
    // GetPage(
    //     name: '/ui/discover',
    //     page: () => const DiscoverJobs(),
    //     middlewares: [AuthMiddleware()]),
    GetPage(
      name: '/ui/landing',
      page: () => const LandingPage(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- Error ----------------///

    GetPage(
      name: '/coming-soon',
      page: () => const ComingSoonPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/error-404',
      page: () => const Error404(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/error-500',
      page: () => const Error500(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/maintenance',
      page: () => const MaintenancePage(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- Chat ----------------///

    GetPage(
      name: '/chat',
      page: () => const ChatPage(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- Form ----------------///

    GetPage(
      name: '/form/basic',
      page: () => const BasicPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/form/validation',
      page: () => const ValidationPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/form/quill-editor',
      page: () => const QuillEditor(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/form/form-mask',
      page: () => const FormMaskPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/form/wizard',
      page: () => const Wizard(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- Other ----------------///

    GetPage(
      name: '/other/basic_tables',
      page: () => const BasicTable(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/other/syncfusion_charts',
      page: () => const SyncFusionChart(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/other/fl_chart',
      page: () => const FlChartScreen(),
      middlewares: [AuthMiddleware()],
    ),

    ///---------------- Maps ----------------///

    GetPage(
      name: '/maps/sf-maps',
      page: () => const SfMapPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/maps/google-maps',
      page: () => const GoogleMapPage(),
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
