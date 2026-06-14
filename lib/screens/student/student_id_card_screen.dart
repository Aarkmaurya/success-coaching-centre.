import 'package:flutter/material.dart';

class StudentIdCardScreen extends StatelessWidget {
  const StudentIdCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.colorScheme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Digital ID Card',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              
              // 1. मुख्य स्टूडेंट आईडी कार्ड (Main ID Card Design)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // कार्ड का हेडर (Header)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'SUCCESS COACHING CENTRE',
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                                ),
                                Text(
                                  'NVS • SAINIK SCHOOL • CHS',
                                  style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // कार्ड का मुख्य भाग (Card Body)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // स्टूडेंट अवतार (Avatar)
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            child: Text(
                              'AM',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Aark Maurya',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'STUDENT',
                            style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 20),
                          
                          // विवरण सूची (Details Grid Table)
                          _buildIdRow('Roll Number', 'SCC-2026-089', theme),
                          const Divider(height: 16),
                          _buildIdRow('Course Chosen', 'Sainik School Prep', theme),
                          const Divider(height: 16),
                          _buildIdRow('Father\'s Name', 'Mr. Maurya', theme),
                          const Divider(height: 16),
                          _buildIdRow('Validity', 'March 2027', theme),
                          
                          const SizedBox(height: 24),
                          
                          // डिजिटल क्यूआर कोड बॉक्स (QR Code Box Mock)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Icon(
                              Icons.qr_code_2_rounded,
                              size: 100,
                              color: theme.colorScheme.primary == theme.scaffoldBackgroundColor ? Colors.black87 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Scan QR for Verification',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // 2. डाउनलोड ऑप्शन्स बटन (Download Controls)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saving ID Card to Photos Gallery...')),
                          );
                        },
                        icon: const Icon(Icons.image_rounded),
                        label: const Text('SAVE IMAGE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Generating PDF File Document...')),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                        label: const Text('DOWNLOAD PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // 3. एलिगेंट डेवलपर पाथ फुटर (Aark Maurya Branding)
              GestureDetector(
                onTap: () => _showDeveloperDialog(context, theme),
                child: Column(
                  children: [
                    const Text(
                      'Designed & Developed by Aark Maurya',
                      style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SUCCESS COACHING CENTRE © 2026',
                      style: TextStyle(fontSize: 9, color: Colors.grey.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildIdRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.between,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  // डेवलपर इनफार्मेशन पॉपअप डायलॉग (About Developer Popup)
  void _showDeveloperDialog(BuildContext context, ThemeData theme) {
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
              child: Icon(Icons.code_rounded, color: theme.colorScheme.primary, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aark Maurya',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
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
                child: const Text('CLOSE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
