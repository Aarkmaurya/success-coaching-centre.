import 'package:flutter/material.dart';

class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({Key? key}) : super(key: key);

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // सैंपल छात्र डेटाबेस - 'final' हटा दिया है ताकि नया छात्र लिस्ट में जुड़ सके
  List<Map<String, String>> _allStudents = [
    {'name': 'Aark Maurya', 'course': 'Sainik School', 'id': 'SCC-2026-089', 'phone': '9876543210'},
    {'name': 'Rahul Kumar', 'course': 'NVS', 'id': 'SCC-2026-045', 'phone': '9123456789'},
    {'name': 'Anjali Singh', 'course': 'CHS', 'id': 'SCC-2026-112', 'phone': '8877665544'},
    {'name': 'Pankaj Tiwari', 'course': 'Sainik School', 'id': 'SCC-2026-012', 'phone': '7766554433'},
    {'name': 'Neha Sharma', 'course': 'NVS', 'id': 'SCC-2026-076', 'phone': '9988776655'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // सर्च क्वेरी के आधार पर छात्रों को फ़िल्टर करना
    final filteredStudents = _allStudents.where((student) {
      final name = student['name']!.toLowerCase();
      final course = student['course']!.toLowerCase();
      final id = student['id']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || course.contains(query) || id.contains(query);
    }).toList();

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
          'Manage Students',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),

      // 1. यहाँ आपका नया फ्लोटिंग एक्शन बटन जुड़ गया है
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddStudentDialog(context, theme),
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Student', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // सर्च बार
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by Name, ID, or Course...',
                  prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.primary),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.15)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // छात्रों की सूची
              Expanded(
                child: filteredStudents.isEmpty
                    ? Center(
                        child: Text(
                          'No students found matching "$_searchQuery"',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredStudents.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final student = filteredStudents[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.06)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                child: Text(
                                  student['name']!.split(' ').map((e) => e[0]).join(),
                                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                                ),
                              ),
                              title: Text(
                                student['name']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ID: ${student['id']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        student['course']!,
                                        style: TextStyle(color: theme.colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary),
                                onPressed: () {
                                  _showStudentDetails(context, student, theme);
                                },
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

  // 2. नया छात्र जोड़ने का सुंदर पॉपअप फॉर्म मेथड (यहाँ जुड़ गया है)
  void _showAddStudentDialog(BuildContext context, ThemeData theme) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String selectedCourse = 'NVS';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('New Admission Register', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl, 
                  decoration: const InputDecoration(labelText: 'Student Full Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneCtrl, 
                  keyboardType: TextInputType.phone, 
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedCourse,
                  items: ['NVS', 'Sainik School', 'CHS'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    setDialogState(() {
                      selectedCourse = val!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Select Course'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                    setState(() {
                                                                                                              _allStudents.add({
                        'name': nameCtrl.text,
                        'course': selectedCourse,
                        'id': 'SCC-2026-${100 + _allStudents.length}',
                        'phone': phoneCtrl.text,
                      });
                    });
                    
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Student Registered Successfully!'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: const Text(
                  'SAVE', 
                  style: TextStyle(color: Colors.white),
                ),
                      _allStudents.add({
                        'name': nameCtrl.text,
                        'course': selectedCourse,
                        'id': 'SCC-2026-${100 + _allStudents.length}',
                        'phone': phoneCtrl.text,
                      });
                    });
                    
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Student Registered Successfully!'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: const Text(
                  'SAVE', 
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // छात्र की डिटेल्स दिखाने वाला पॉपअप मेथड
  void _showStudentDetails(BuildContext context, Map<String, String> student, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(student['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Roll No:', student['id']!),
            _buildDetailRow('Course:', student['course']!),
            _buildDetailRow('Mobile:', student['phone']!),
            _buildDetailRow('Institute:', 'SUCCESS COACHING CENTRE'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
