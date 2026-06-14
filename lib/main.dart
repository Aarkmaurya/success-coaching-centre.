import 'package:flutter/material.dart';
import 'core/themes/app_themes.dart';
import 'screens/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SuccessCoachingApp());
}

class SuccessCoachingApp extends StatefulWidget {
  const SuccessCoachingApp({Key? key}) : super(key: key);

  @override
  State<SuccessCoachingApp> createState() => _SuccessCoachingAppState();

  // पूरे ऐप में कहीं से भी थीम बदलने के लिए एक स्टेटिक मेथड
  static _SuccessCoachingAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_SuccessCoachingAppState>();
  }
}

class _SuccessCoachingAppState extends State<SuccessCoachingApp> {
  // डिफॉल्ट रूप से 'Professional Blue' थीम सेट रहेगी
  ThemeData _currentTheme = AppThemes.professionalBlue;
  String _currentThemeName = 'Professional Blue';

  void changeTheme(String themeName) {
    setState(() {
      _currentThemeName = themeName;
      switch (themeName) {
        case 'Dark Mode':
          _currentTheme = AppThemes.darkMode;
          break;
        case 'Emerald Green':
          _currentTheme = AppThemes.emeraldGreen;
          break;
        case 'Purple Premium':
          _currentTheme = AppThemes.purplePremium;
          break;
        case 'Gold Elite':
          _currentTheme = AppThemes.goldElite;
          break;
        case 'Light Modern':
          _currentTheme = AppThemes.lightModern;
          break;
        default:
          _currentTheme = AppThemes.professionalBlue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUCCESS COACHING CENTRE',
      debugShowCheckedModeBanner: false,
      theme: _currentTheme,
      // सबसे पहले ऐप लॉगिन स्क्रीन पर खुलेगा
      home: const LoginScreen(), 
    );
  }
}

