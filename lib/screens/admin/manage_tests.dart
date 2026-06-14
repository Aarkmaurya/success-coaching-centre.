import 'package:flutter/material.dart';

class ManageTestsScreen extends StatefulWidget {
  const ManageTestsScreen({Key? key}) : super(key: key);

  @override
  State<ManageTestsScreen> createState() => _ManageTestsScreenState();
}

class _ManageTestsScreenState extends State<ManageTestsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // टेस्ट की मुख्य डिटेल्स के कंट्रोलर्स
  final _testTitleController = TextEditingController();
  final _durationController = TextEditingController();
  
  String? _selectedCourse;
  final List<String> _courses = ['NVS', 'Sainik School', 'CHS'];

  // नेगेटिव मार्किंग के वेरिएबल्स (आपके नियम के अनुसार)
  bool _isNegativeMarkingOn = false;
  double _negativeValue = -0.25;
  final List<double> _negativeOptions = [-0.25, -0.50, -1.0];

  // नया सवाल जोड़ने के कंट्रोलर्स
  final _questionTextController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(4, (_) => TextEditingController());
  final _explanationController = TextEditingController();
  int _correctOptionIndex = 0; // डिफॉल्ट रूप से पहला ऑप्शन सही टिक रहेगा
  // जोड़े गए सवालों को लोकल मेमोरी में रखने के लिए लिस्ट
  List<Map<String, dynamic>> _addedQuestions = [];
  
  @override
  void dispose() {
    _testTitleController.dispose();
    _durationController.dispose();
    _questionTextController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    _explanationController.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Test Creation Panel',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. टेस्ट की बेसिक डिटेल्स कार्ड
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
                      const Text('1. Test Basic Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _testTitleController,
                        decoration: InputDecoration(
                          hintText: 'Exam Title (e.g. Mega Mock Test 1)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCourse,
                              hint: const Text('Select Course'),
                              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                              items: _courses.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                              onChanged: (val) => setState(() => _selectedCourse = val),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Duration (Mins)',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. नेगेटिव मार्किंग टॉगल पैनल (Negative Marking Switch)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.gavel_rounded, color: _isNegativeMarkingOn ? Colors.red : Colors.grey),
                              const SizedBox(width: 12),
                              const Text('Negative Marking System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          Switch(
                            value: _isNegativeMarkingOn,
                            activeColor: Colors.red,
                            onChanged: (value) {
                              setState(() {
                                _isNegativeMarkingOn = value;
                              });
                            },
                          ),
                        ],
                      ),
                      if (_isNegativeMarkingOn) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            const Text('Set Penalty Score:', style: TextStyle(fontWeight: FontWeight.w500)),
                            DropdownButton<double>(
                              value: _negativeValue,
                              items: _negativeOptions.map((val) {
                                return DropdownMenuItem(value: val, child: Text('$val Marks'));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _negativeValue = val);
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. सवाल और ऑप्शंस जोड़ने का फॉर्म (Add Question Section)
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
                      const Text('2. Add Questions (MCQ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _questionTextController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Enter Question Text Here...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Enter Options & Select Correct Answer (✔):', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      
                      // 4 ऑप्शंस की लिस्ट रेडियो बटन के साथ टिक करने के लिए
                      ...List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: _correctOptionIndex,
                                activeColor: Colors.green,
                                onChanged: (val) => setState(() => _correctOptionIndex = val!),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _optionControllers[index],
                                  decoration: InputDecoration(
                                    hintText: 'Option ${index + 1}',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCourse,
                              hint: const Text('Select Course'),
                              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                              items: _courses.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                              onChanged: (val) => setState(() => _selectedCourse = val),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Duration (Mins)',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. नेगेटिव मार्किंग टॉगल पैनल (Negative Marking Switch)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.gavel_rounded, color: _isNegativeMarkingOn ? Colors.red : Colors.grey),
                              const SizedBox(width: 12),
                              const Text('Negative Marking System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          Switch(
                            value: _isNegativeMarkingOn,
                            activeColor: Colors.red,
                            onChanged: (value) {
                              setState(() {
                                _isNegativeMarkingOn = value;
                              });
                            },
                          ),
                        ],
                      ),
                      if (_isNegativeMarkingOn) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            const Text('Set Penalty Score:', style: TextStyle(fontWeight: FontWeight.w500)),
                            DropdownButton<double>(
                              value: _negativeValue,
                              items: _negativeOptions.map((val) {
                                return DropdownMenuItem(value: val, child: Text('$val Marks'));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _negativeValue = val);
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. सवाल और ऑप्शंस जोड़ने का फॉर्म (Add Question Section)
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
                      const Text('2. Add Questions (MCQ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _questionTextController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Enter Question Text Here...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Enter Options & Select Correct Answer (✔):', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      
                      ...List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: _correctOptionIndex,
                                activeColor: Colors.green,
                                onChanged: (val) => setState(() => _correctOptionIndex = val!),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _optionControllers[index],
                                  decoration: InputDecoration(
                                    hintText: 'Option ${index + 1}',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                                            const SizedBox(height: 16),
                      
                      // सवाल को लिस्ट में जोड़ने का नया बटन
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (_questionTextController.text.isNotEmpty) {
                              setState(() {
                                // सवाल को आपकी _addedQuestions लिस्ट में सेव करना
                                _addedQuestions.add({
                                  'question': _questionTextController.text,
                                  'options': [
                                    _optionControllers[0].text,
                                    _optionControllers[1].text,
                                    _optionControllers[2].text,
                                    _optionControllers[3].text,
                                  ],
                                  'correctIndex': _correctOptionIndex,
                                  'explanation': _explanationController.text,
                                });
                                
                                // अगला सवाल लिखने के लिए सारे बॉक्स खाली करना
                                _questionTextController.clear();
                                _explanationController.clear();
                                for (var controller in _optionControllers) {
                                  controller.clear();
                                }
                                _correctOptionIndex = 0; // पहले ऑप्शन पर वापस टिक
                              });

                              // स्क्रीन पर सफलता का मैसेज दिखाना
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Question ${_addedQuestions.length} added successfully!'),
                                  backgroundColor: theme.colorScheme.primary,
                                ),
                              );
                            } else {
                              // अगर बिना सवाल लिखे बटन दबाया तो वार्निंग देना
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter question text first!')),
                              );
                            }
                          },
                          icon: const Icon(Icons.add_task_rounded),
                          label: const Text('Add This Question', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 4. ड्राफ्ट और पब्लिश बटन एक्शन रूम
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Test Saved to Drafts Successfully.')),
                            );
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('SAVE DRAFT', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Test Published Successfully on SUCCESS COACHING CENTRE!'),
                                backgroundColor: theme.colorScheme.primary,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: const Text('PUBLISH TEST', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}