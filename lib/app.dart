import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'ui/screens/auth_gate.dart';

class LeoPayApp extends StatelessWidget {
  const LeoPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LEOPay',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF0D2B45),
          secondary: const Color(0xFF21C7C7),
          surface: const Color(0xFFF2F2F2),
          background: const Color(0xFFF2F2F2),
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF0D2B45),
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D2B45),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        textTheme: baseTextTheme,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.authGate,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.authGate) {
          return MaterialPageRoute(
            builder: (_) => const AuthGate(),
          );
        }
        return RouteGenerator.generateRoute(settings);
      },
    );
  }
}
