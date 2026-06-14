import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  // बैनर में दिखने वाले ऑफर्स या नोटिस की लिस्ट
  final List<Map<String, String>> _banners = [
    {
      'title': 'New Batches Opened!',
      'subtitle': 'NVS, CHS & Sainik School 2026 Preparation',
      'color': '0xFF1D4ED8'
    },
    {
      'title': 'Weekly Mega Mock Test',
      'subtitle': 'Live this Sunday at 10:00 AM sharp',
      'color': '0xFF7C3AED'
    },
    {
      'title': 'Free PDF Notes Available',
      'subtitle': 'Download latest study materials now',
      'color': '0xFF059669'
    },
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.colorScheme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. कोचिंग और छात्र का नाम (Header)
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SUCCESS COACHING CENTRE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Welcome, Student 👋',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                      child: Icon(Icons.notifications_active_outlined, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. ऑटोमैटिक या स्वाइप होने वाला बैनर स्लाइडर
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: _banners.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBannerIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final banner = _banners[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(int.parse(banner['color']!)),
                              Color(int.parse(banner['color']!)).withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              banner['title']!,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              banner['subtitle']!,
                              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // बैनर के डॉट्स इंडिकेटर
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _banners.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentBannerIndex == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentBannerIndex == index ? theme.colorScheme.primary : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // 3. छात्र एक्टिविटी प्रोग्रेस ग्रिड (Score, Tests)
                const Text(
                  'Your Performance Summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildProgressCard(
                        'Average Score',
                        '84.5%',
                        Icons.analytics_outlined,
                        theme.colorScheme.primary,
                        theme,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildProgressCard(
                        'Total Attempted',
                        '12 Tests',
                        Icons.task_alt_rounded,
                        const Color(0xFF059669),
                        theme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // 4. हालिया सूचना बोर्ड (Announcements)
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    const Text(
                      'Latest Announcements',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('View All', style: TextStyle(color: theme.colorScheme.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD97706).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.campaign_rounded, color: Color(0xFFD97706)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sainik School Form Out!',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'The registration forms for Sainik School entrance exams are out. Kindly submit details to the office before the deadline.',
                              style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // प्रोग्रेस कार्ड्स बनाने का हेल्पर मेथड
  Widget _buildProgressCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            radius: 20,
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}