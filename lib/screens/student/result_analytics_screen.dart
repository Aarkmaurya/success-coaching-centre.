import 'package:flutter/material.dart';

class ResultAnalyticsScreen extends StatelessWidget {
  final Map<String, dynamic> resultData;

  const ResultAnalyticsScreen({Key? key, required this.resultData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.colorScheme.brightness == Brightness.dark;

    // डेटा को सुरक्षित रूप से निकालना
    String testTitle = resultData['testTitle'] ?? 'Exam Result';
    String submissionType = resultData['submissionType'] ?? 'Manual Submit';
    int totalQuestions = resultData['totalQuestions'] ?? 0;
    int correct = resultData['correct'] ?? 0;
    int wrong = resultData['wrong'] ?? 0;
    int unattempted = resultData['unattempted'] ?? 0;
    double finalScore = resultData['finalScore'] ?? 0.0;
    int timeTakenSeconds = resultData['timeTakenSeconds'] ?? 0;

    // गणना (Calculations)
    double maxMarks = totalQuestions * 4.0;
    double percentage = maxMarks > 0 ? (finalScore / maxMarks) * 100 : 0.0;
    int totalAttempted = correct + wrong;
    double accuracy = totalAttempted > 0 ? (correct / totalAttempted) * 100 : 0.0;
    
    // Questions Per Minute (QPM) की गणना
    double minutesTaken = timeTakenSeconds / 60;
    double qpm = minutesTaken > 0 ? totalAttempted / minutesTaken : 0.0;

    String formatDuration(int totalSecs) {
      int mins = totalSecs ~/ 60;
      int secs = totalSecs % 60;
      return '$mins Min $secs Sec';
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Exam Analytics & Performance',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. मुख्य स्कोर कार्ड (Score Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.85)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: Column(
                  children: [
                    Text(
                      testTitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${finalScore.toStringAsFixed(1)} / ${maxMarks.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
                    ),
                    const Text(
                      'Your Final Score',
                      style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white30, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildHeaderStat('Percentage', '${percentage.toStringAsFixed(1)}%'),
                        _buildHeaderStat('Submission', submissionType),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. एडवांस्ड मैट्रिक्स ग्रिड (Accuracy, QPM, Time Taken)
              const Text(
                'Speed & Accuracy Analytics',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Accuracy',
                      '${accuracy.toStringAsFixed(1)}%',
                      Icons.gpp_good_rounded,
                      const Color(0xFF059669),
                      theme,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      'Speed (QPM)',
                      '${qpm.toStringAsFixed(2)} Qs/M',
                      Icons.speed_rounded,
                      const Color(0xFFD97706),
                      theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      child: Icon(Icons.av_timer_rounded, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDuration(timeTakenSeconds),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Text(
                          'Total Time Consumed',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 3. विजुअल ब्रेकडाउन (Question Summary Bars)
              const Text(
                'Question Breakdown',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 16),
              _buildBreakdownBar('Correct Answers', correct, totalQuestions, const Color(0xFF059669), theme),
              const SizedBox(height: 12),
              _buildBreakdownBar('Wrong Answers', wrong, totalQuestions, Colors.red, theme),
              const SizedBox(height: 12),
              _buildBreakdownBar('Unattempted Questions', unattempted, totalQuestions, Colors.grey, theme),
              const SizedBox(height: 32),

              // 4. होम स्क्रीन पर वापस जाने का बटन
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'GO BACK TO DASHBOARD',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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

  // स्कोर कार्ड के छोटे स्टेट्स
  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  // मैट्रिक्स कार्ड्स
  Widget _buildMetricCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.12), radius: 18, child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
  // सुंदर प्रोग्रेस बार ब्रेकडाउन
  Widget _buildBreakdownBar(String label, int value, int total, Color color, ThemeData theme) {
    double barProgress = total > 0 ? value / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            Text('$value / $total', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: barProgress,
            minHeight: 10,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.05),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
