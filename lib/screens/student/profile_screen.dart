import 'package:flutter/material.dart';
import '../../main.dart';
import 'student_id_card_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // आपकी बताई हुई सभी 6 थीम्स की लिस्ट
  final List<String> _themesList = [
    'Professional Blue',
    'Dark Mode',
    'Emerald Green',
    'Purple Premium',
    'Gold Elite',
    'Light Modern'
  ];

  // डिफॉल्ट रूप से सिलेक्टेड थीम नाम
  String _selectedThemeName = 'Professional Blue';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.colorScheme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Student Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 1. प्रोफाइल अवतार और नाम कार्ड
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                      child: Text(
                        'AM',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aark Maurya',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Course: Sainik School',
                        style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 2. लाइव थीम चेंजर पैनल (Theme Changer Dropdown)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.palette_outlined, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        const Text(
                          'App Styling Theme',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedThemeName,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                      items: _themesList.map((String currentTheme) {
                        return DropdownMenuItem<String>(
                          value: currentTheme,
                          child: Text(currentTheme),
                        );
                      }).toList(),
                      onChanged: (newThemeName) {
                        if (newThemeName != null) {
                          setState(() {
                            _selectedThemeName = newThemeName;
                          });
                          // main.dart की स्टेट चेंज मेथड को ट्रिगर करना (जादुई चेंज)
                          SuccessCoachingApp.of(context)?.changeTheme(newThemeName);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. पर्सनल डिटेल्स की लिस्ट (Personal Records)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    _buildProfileRow('Father\'s Name', 'Mr. Coaching Father', Icons.supervisor_account_outlined, theme),
                    const Divider(height: 24),
                    _buildProfileRow('Mobile Number', '+91 9876543210', Icons.phone_android_rounded, theme),
                    const Divider(height: 24),
                    _buildProfileRow('School Name', 'Government High School', Icons.school_outlined, theme),
                    const Divider(height: 24),
                    _buildProfileRow('Address', 'Patna, Bihar, India', Icons.home_outlined, theme),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. डिजिटल स्टूडेंट आईडी कार्ड पर जाने का बटन
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StudentIdCardScreen()),
                    );
                  },
                  icon: const Icon(Icons.qr_code_2_rounded, color: Colors.white),
                  label: const Text(
                    'VIEW STUDENT ID CARD',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
