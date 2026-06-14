import 'package:flutter/material.dart';
import 'test_exam_screen.dart';

class TestListScreen extends StatefulWidget {
  const TestListScreen({Key? key}) : super(key: key);

  @override
  State<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  // सैंपल टेस्ट डेटा (भविष्य में यह फायरस्टोर से आएगा)
  final List<Map<String, dynamic>> _availableTests = [
    {
      'id': 'test_01',
      'title': 'NVS Mega Mock Test 1',
      'course': 'NVS',
      'totalQuestions': 80,
      'totalMarks': 100,
      'durationMinutes': 120,
      'hasNegativeMarking': true,
      'negativeValue': -0.25,
    },
    {
      'id': 'test_02',
      'title': 'Sainik School Maths Practice',
      'course': 'Sainik School',
      'totalQuestions': 50,
      'totalMarks': 150,
      'durationMinutes': 90,
      'hasNegativeMarking': false,
      'negativeValue': 0.0,
    },
    {
      'id': 'test_03',
      'title': 'CHS General Science Quiz',
      'course': 'CHS',
      'totalQuestions': 30,
      'totalMarks': 30,
      'durationMinutes': 40,
      'hasNegativeMarking': true,
      'negativeValue': -0.50,
    },
  ];

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
          'Online Test Series',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // शीर्ष सूचना पट्टी
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Select a test below to start your exam. Do not close the app during the test.',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Available Exams',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),

              // टेस्ट कार्ड्स की लिस्ट
              Expanded(
                child: ListView.builder(
                  itemCount: _availableTests.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final test = _availableTests[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // कोर्स टैग और टेस्ट नाम
                            Row(
                              mainAxisAlignment: MainAxisAlignment.between,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    test['course'],
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (test['hasNegativeMarking'])
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Negative: ${test['negativeValue']}',
                                      style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              test['title'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            
                            // टेस्ट के नियम और जानकारी ग्रिड
                            Row(
                              mainAxisAlignment: MainAxisAlignment.between,
                              children: [
                                _buildInfoChip(Icons.help_outline_rounded, '${test['totalQuestions']} Qs', theme),
                                _buildInfoChip(Icons.stars_rounded, '${test['totalMarks']} Marks', theme),
                                _buildInfoChip(Icons.timer_outlined, '${test['durationMinutes']} Mins', theme),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // टेस्ट शुरू करने का बटन
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TestExamScreen(testData: test),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'START TEST',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // जानकारी वाले छोटे छोटे चिप्स बनाने का विजेट
  Widget _buildInfoChip(IconData icon, String label, ThemeData theme) {
    final isDark = theme.colorScheme.brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13, 
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
