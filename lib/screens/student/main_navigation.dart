import 'package:flutter/material.dart';
// आपकी सभी असली फाइल्स को यहाँ एक साथ लिंक कर दिया गया है
import 'dashboard_screen.dart';
import 'test_list_screen.dart';
import 'notes_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // 5 मुख्य असली स्क्रीन्स की बिल्कुल सही लिस्ट
  final List<Widget> _screens = [
    const DashboardScreen(),     // होम स्क्रीन
    const TestListScreen(),      // ऑनलाइन टेस्ट सीरीज
    const NotesScreen(),         // डाउनलोड और पीडीएफ नोट्स
    const LeaderboardScreen(),   // कोचिंग लीडरबोर्ड रैंकिंग
    const ProfileScreen(),       // छात्र प्रोफाइल और थीम चेंजर
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.colorScheme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      // सुंदर मॉडर्न कैप्सूल बॉटम नेविगेशन बार
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(35), // बाहरी कैप्सूल बॉर्डर
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home', theme),
                _buildNavItem(1, Icons.assignment_rounded, 'Exams', theme),
                _buildNavItem(2, Icons.cloud_done_rounded, 'Notes', theme),
                _buildNavItem(3, Icons.bar_chart_rounded, 'Ranking', theme),
                _buildNavItem(4, Icons.person_rounded, 'Profile', theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // हर एक नेविगेशन बटन को एनीमेशन के साथ डिजाइन करने वाला हेल्पर मेथड
  Widget _buildNavItem(int index, IconData icon, String label, ThemeData theme) {
    final isSelected = _selectedIndex == index;
    final isDark = theme.colorScheme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          // एक्टिव होने पर हल्का रंगीन गोल बॉक्स (Pill Shape) बनेगा
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(isDark ? 0.25 : 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? theme.colorScheme.primary
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
