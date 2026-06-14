import 'package:flutter/material.dart';

class AppThemes {
  // 1. Professional Blue Theme (App Default)
  static ThemeData get professionalBlue {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF1D4ED8),
      scaffoldBackgroundColor: const Color(0xFFF3F8FE),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1D4ED8),
        secondary: Color(0xFF3B82F6),
        surface: Colors.white,
        background: Color(0xFFF3F8FE),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF334155)),
      ),
    );
  }

  // 2. Dark Mode Theme
  static ThemeData get darkMode {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF3B82F6),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3B82F6),
        secondary: Color(0xFF60A5FA),
        surface: Color(0xFF1E293B),
        background: Color(0xFF0F172A),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE2E8F0)),
      ),
    );
  }

  // 3. Emerald Green Theme
  static ThemeData get emeraldGreen {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF059669),
      scaffoldBackgroundColor: const Color(0xFFF0FDF4),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF059669),
        secondary: Color(0xFF10B981),
        surface: Colors.white,
        background: Color(0xFFF0FDF4),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF064E3B)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
      ),
    );
  }

  // 4. Purple Premium Theme
  static ThemeData get purplePremium {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF7C3AED),
      scaffoldBackgroundColor: const Color(0xFFF5F3FF),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF7C3AED),
        secondary: Color(0xFF8B5CF6),
        surface: Colors.white,
        background: Color(0xFFF5F3FF),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4C1D95)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
      ),
    );
  }

  // 5. Gold Elite Theme
  static ThemeData get goldElite {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFFD97706),
      scaffoldBackgroundColor: const Color(0xFFFFFBEB),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD97706),
        secondary: Color(0xFFF59E0B),
        surface: Colors.white,
        background: Color(0xFFFFFBEB),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
      ),
    );
  }

  // 6. Light Modern Theme
  static ThemeData get lightModern {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF475569),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF475569),
        secondary: Color(0xFF64748B),
        surface: Colors.white,
        background: Color(0xFFF8FAFC),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF334155)),
      ),
    );
  }
}

