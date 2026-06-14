import 'dart:async';
import 'package:flutter/material.dart';
import 'result_analytics_screen.dart';

class TestExamScreen extends StatefulWidget {
  final Map<String, dynamic> testData;
  const TestExamScreen({Key? key, required this.testData}) : super(key: key);

  @override
  State<TestExamScreen> createState() => _TestExamScreenState();
}

class _TestExamScreenState extends State<TestExamScreen> {
  late int _remainingSeconds;
  Timer? _timer;
  int _currentQuestionIndex = 0;
  
  // छात्र द्वारा चुने गए जवाबों को स्टोर करने के लिए (Question Index -> Selected Option Index)
  final Map<int, int> _selectedAnswers = {};
  
  // सैंपल सवाल (फायरस्टोर से आने वाले सवालों का ढांचा)
  final List<Map<String, dynamic>> _mockQuestions = [
    {
      'questionText': 'What is the capital city of India?',
      'options': ['Mumbai', 'Delhi', 'Lucknow', 'Jaipur'],
      'correctAnswerIndex': 1,
      'explanation': 'Delhi became the capital of India in 1911.',
      'subject': 'General Knowledge'
    },
    {
      'questionText': 'Which planet is known as the Red Planet?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      'correctAnswerIndex': 1,
      'explanation': 'Mars appears red due to iron oxide (rust) on its surface.',
      'subject': 'General Knowledge'
    },
    {
      'questionText': 'What is 15 multiplied by 6?',
      'options': ['80', '85', '90', '95'],
      'correctAnswerIndex': 2,
      'explanation': '15 * 6 = 90.',
      'subject': 'Mathematics'
    }
  ];

  @override
  void initState() {
    super.initState();
    // मिनट को सेकंड में बदलें
    _remainingSeconds = widget.testData['durationMinutes'] * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        // हर 10 सेकंड में ऑटो-सेव प्रोग्रेस को मिमिक (mimic) करने के लिए
        if (_remainingSeconds % 10 == 0) {
          debugPrint("Answers auto-saved to secure local cache...");
        }
      } else {
        _timer?.cancel();
        _submitTest(submissionType: 'Auto Submit'); // समय खत्म होने पर ऑटो-सबमिट
      }
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _submitTest({required String submissionType}) {
    _timer?.cancel();
    
    int totalQuestions = _mockQuestions.length;
    int correctAnswers = 0;
    int wrongAnswers = 0;
    int unattempted = 0;

    for (int i = 0; i < totalQuestions; i++) {
      if (_selectedAnswers.containsKey(i)) {
        if (_selectedAnswers[i] == _mockQuestions[i]['correctAnswerIndex']) {
          correctAnswers++;
        } else {
          wrongAnswers++;
        }
      } else {
        unattempted++;
      }
    }

    // कुल मार्क्स और नेगेटिव मार्किंग की गणना
    double finalScore = correctAnswers * 4.0; // प्रति प्रश्न 4 अंक मानकर
    if (widget.testData['hasNegativeMarking'] == true) {
      double penalty = widget.testData['negativeValue']; // जैसे -0.25 या -0.50
      finalScore += (wrongAnswers * penalty);
    }

    int timeTakenSeconds = (widget.testData['durationMinutes'] * 60) - _remainingSeconds;

    // रिजल्ट एनालिसिस स्क्रीन पर डेटा ट्रांसफर करें
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultAnalyticsScreen(
          resultData: {
            'testTitle': widget.testData['title'],
            'submissionType': submissionType,
            'totalQuestions': totalQuestions,
            'correct': correctAnswers,
            'wrong': wrongAnswers,
            'unattempted': unattempted,
            'finalScore': finalScore,
            'timeTakenSeconds': timeTakenSeconds,
            'questionsData': _mockQuestions,
            'userAnswers': _selectedAnswers,
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // बैक बटन दबाने पर वार्निंग पॉपअप
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Warning!'),
        content: const Text('Do not close or leave the exam screen. Your progress might be lost or auto-submitted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('STAY HERE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              _submitTest(submissionType: 'Manual Submit (Aborted)');
            },
            child: const Text('SUBMIT & LEAVE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return shouldLeave ?? false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentQuestion = _mockQuestions[_currentQuestionIndex];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          automaticallyImplyLeading: false,
          title: Text(
            widget.testData['title'],
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            // काउंटडाउन टाइमर विजेट
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // प्रोग्रेस बार और प्रश्न संख्या संकेत
            Container(
              color: theme.colorScheme.primary.withOpacity(0.05),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${_mockQuestions.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    currentQuestion['subject'],
                    style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ),

            // मुख्य प्रश्न और ऑप्शंस एरिया
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // प्रश्न का टेक्स्ट
                    Text(
                      currentQuestion['questionText'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                    ),
                    const SizedBox(height: 24),

                    // ऑप्शंस की लिस्ट (A, B, C, D)
                    ...List.generate(currentQuestion['options'].length, (index) {
                      final optionText = currentQuestion['options'][index];
                      final isSelected = _selectedAnswers[_currentQuestionIndex] == index;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.colorScheme.primary.withOpacity(0.08) : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.15),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: RadioListTile<int>(
                          value: index,
                          groupValue: _selectedAnswers[_currentQuestionIndex],
                          title: Text(
                            optionText,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? theme.colorScheme.primary : Colors.black87,
                            ),
                          ),
                          activeColor: theme.colorScheme.primary,
                          onChanged: (value) {
                            setState(() {
                              _selectedAnswers[_currentQuestionIndex] = value!;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            // नीचे का कंट्रोल नेविगेशन बार (Next, Previous, Submit)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  // पिछला सवाल बटन
                  OutlinedButton(
                    onPressed: _currentQuestionIndex > 0
                        ? () {
                            setState(() {
                              _currentQuestionIndex--;
                            });
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('PREVIOUS'),
                  ),

                  // अगला सवाल या सबमिट बटन
                  _currentQuestionIndex < _mockQuestions.length - 1
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentQuestionIndex++;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('NEXT', style: TextStyle(color: Colors.white)),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            // सबमिट करने से पहले कन्फर्मेशन पॉपअप
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: const Text('Submit Exam?'),
                                content: const Text('Are you sure you want to finish and submit your answers?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // पॉपअप बंद करें
                                      _submitTest(submissionType: 'Manual Submit');
                                    },
                                    child: const Text('SUBMIT', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669), // हरा रंग सबमिट के लिए
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('SUBMIT TEST', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

