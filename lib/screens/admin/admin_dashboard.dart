import 'package:flutter/material.dart';
import 'manage_students.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

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
          'Admin Control Room',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Admin Brand Welcome Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: theme.colorScheme.primary.withOpacity(0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SUCCESS COACHING CENTRE',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome, System Director',
                    style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22),
                  ),
                ],
              ),
            ),
            
            // 2. Main Admin Grid Operations Board Area
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildAdminCard('Manage Students', Icons.people_alt_rounded, Colors.blue, context),
                  _buildAdminCard('Create MCQ Tests', Icons.quiz_rounded, Colors.orange, context),
                  _buildAdminCard('Upload Notes PDF', Icons.picture_as_pdf_rounded, Colors.red, context),
                  _buildAdminCard('Mark Attendance', Icons.co_present_rounded, Colors.green, context),
                  _buildAdminCard('Announcements', Icons.campaign_rounded, Colors.purple, context),
                  _buildAdminCard('Institute Analytics', Icons.stacked_bar_chart_rounded, Colors.teal, context),
                ],
              ),
            ),
            
            // 3. Elegant Professional Footer Signature (Aark Maurya)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () => _showDeveloperPopup(context, theme),
                child: Column(
                  children: [
                    const Text(
                      'Designed & Developed by Aark Maurya',
                      style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'SUCCESS COACHING CENTRE Control Panel v1.0',
                      style: TextStyle(fontSize: 9, color: Colors.grey.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper template method to easily spin up actionable dashboard icons
  // पुराना कोड हटाकर इस तरह बदलें:
  Widget _buildAdminCard(String title, IconData icon, Color color, BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        // यहाँ हम चेक करेंगे कि कौन सा बटन दबाया गया है
        if (title == 'Manage Students') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManageStudentsScreen()),
          );
        } else {
          // बाकी बटनों के लिए अभी सिर्फ मैसेज दिखेगा जब तक हम उनका कोड नहीं बना लेते
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $title Management Module...'),
              backgroundColor: theme.colorScheme.primary,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Developer context modal dialogue action loop trigger block
  void _showDeveloperPopup(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
              child: Icon(Icons.developer_mode_rounded, color: theme.colorScheme.primary, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aark Maurya',
              style: TextStyle(fontWeight: FontWeight.black, fontSize: 20),
            ),
            Text(
              'IT Student & Developer',
              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 16),
            const Text(
              'Passionate about web development, technology and educational solutions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('CLOSE PANEL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}