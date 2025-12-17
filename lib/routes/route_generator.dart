import 'package:flutter/material.dart';

import '../ui/screens/dashboard_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/send_money_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case AppRoutes.sendMoney:
        return MaterialPageRoute(builder: (_) => const SendMoneyScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );
    }
  }
}
