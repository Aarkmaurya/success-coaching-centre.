import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // सैंपल लीडरबोर्ड डेटा (भविष्य में यह फायरस्टोर क्वेरी से आएगा)
  final List<Map<String, dynamic>> _weeklyRankings = [
    {'rank': 1, 'name': 'Aark Maurya', 'score': '390/400', 'avatar': 'AM', 'isTop': true},
    {'rank': 2, 'name': 'Rahul Kumar', 'score': '375/400', 'avatar': 'RK', 'isTop': true},
    {'rank': 3, 'name': 'Anjali Singh', 'score': '362/400', 'avatar': 'AS', 'isTop': true},
    {'rank': 4, 'name': 'Pankaj Tiwari', 'score': '345/400', 'avatar': 'PT', 'isTop': false},
    {'rank': 5, 'name': 'Neha Sharma', 'score': '330/400', 'avatar': 'NS', 'isTop': false},
    {'rank': 6, 'name': 'Amit Patel', 'score': '312/400', 'avatar': 'AP', 'isTop': false},
  ];

  final List<Map<String, dynamic>> _monthlyRankings = [
    {'rank': 1, 'name': 'Anjali Singh', 'score': '1560/1600', 'avatar': 'AS', 'isTop': true},
    {'rank': 2, 'name': 'Aark Maurya', 'score': '1540/1600', 'avatar': 'AM', 'isTop': true},
    {'rank': 3, 'name': 'Rahul Kumar', 'score': '1490/1600', 'avatar': 'RK', 'isTop': true},
    {'rank': 4, 'name': 'Neha Sharma', 'score': '1420/1600', 'avatar': 'NS', 'isTop': false},
    {'rank': 5, 'name': 'Pankaj Tiwari', 'score': '1380/1600', 'avatar': 'PT', 'isTop': false},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Coaching Leaderboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Weekly Ranking'),
            Tab(text: 'Monthly Ranking'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardList(_weeklyRankings, theme),
          _buildLeaderboardList(_monthlyRankings, theme),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<Map<String, dynamic>> rankings, ThemeData theme) {
    final topThree = rankings.where((user) => user['isTop'] == true).toList();
    final remaining = rankings.where((user) => user['isTop'] == false).toList();

    // रैंकिंग के क्रम को पोडियम पोजीशन (2nd, 1st, 3rd) में व्यवस्थित करना
    List<Map<String, dynamic>> podiumOrder = [];
    if (topThree.length >= 2) podiumOrder.add(topThree[1]); // 2nd Rank
    if (topThree.isNotEmpty) podiumOrder.add(topThree[0]); // 1st Rank
    if (topThree.length >= 3) podiumOrder.add(topThree[2]); // 3rd Rank

    return Column(
      children: [
        // 1. टॉप 3 पोडियम विजुअल एरिया (Podium UI)
        if (podiumOrder.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            color: theme.colorScheme.primary.withOpacity(0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: podiumOrder.map((user) {
                double avatarRadius = user['rank'] == 1 ? 36.0 : 28.0;
                Color medalColor = user['rank'] == 1 
                    ? const Color(0xFFFFD700) 
                    : (user['rank'] == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32));

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: medalColor, width: 3)),
                          child: CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            child: Text(user['avatar'], style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: avatarRadius * 0.5)),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -12),
                          child: Icon(Icons.workspace_premium_rounded, color: medalColor, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(user['name'], style: TextStyle(fontWeight: user['rank'] == 1 ? FontWeight.bold : FontWeight.w600, fontSize: user['rank'] == 1 ? 14 : 12)),
                    Text(user['score'], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(color: medalColor, borderRadius: BorderRadius.circular(10)),
                      child: Text('Rank ${user['rank']}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

        // 2. बाकी बचे हुए छात्रों की लिस्ट स्क्रॉल व्यू
        Expanded(
          child: ListView.builder(
            itemCount: remaining.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemBuilder: (context, index) {
              final user = remaining[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.06)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.12), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text('${user['rank']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.06),
                      child: Text(user['avatar'], style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                    Text(
                      user['score'],
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}