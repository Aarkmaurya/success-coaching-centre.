import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _selectedCategory = 'PDF'; // डिफ़ॉल्ट रूप से PDF सिलेक्ट रहेगा
  final List<String> _categories = ['All', 'Video', 'PDF', 'Test'];

  // सैंपल नोट्स डेटा (भविष्य में यह फायरस्टोर डेटाबेस से लोड होगा)
  final List<Map<String, dynamic>> _mockNotes = [
    {
      'title': 'NVS Mathematics Chapter 1 Notes',
      'course': 'NVS',
      'class': 'Class 6',
      'type': 'PDF',
      'size': '2.4 MB',
    },
    {
      'title': 'Sainik School Intelligence Test Guide',
      'course': 'Sainik School',
      'class': 'Class 6',
      'type': 'PDF',
      'size': '4.1 MB',
    },
    {
      'title': 'CHS General Science Short Revision Notes',
      'course': 'CHS',
      'class': 'Class 9',
      'type': 'PDF',
      'size': '1.8 MB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.colorScheme.brightness == Brightness.dark;

    // चुनी हुई कैटेगरी के हिसाब से नोट्स को फिल्टर करना
    List<Map<String, dynamic>> filteredNotes = [];
    if (_selectedCategory == 'All') {
      filteredNotes = _mockNotes;
    } else {
      filteredNotes = _mockNotes.where((note) => note['type'] == _selectedCategory).toList();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Downloads & Study Materials',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. आपके लेआउट जैसा कैप्सूल चिप्स हॉरिजॉन्टल स्क्रॉल बार (Filter Chips)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.15),
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // 2. नोट्स लिस्ट या खाली कार्टून स्टेट एरिया (Dynamic Content Room)
            Expanded(
              child: filteredNotes.isEmpty
                  ? _buildEmptyCartoonState(theme, isDark) // अगर डेटा खाली है (जैसे Video या Test दबाने पर)
                  : _buildNotesList(filteredNotes, theme, isDark), // अगर पीडीएफ डेटा मौजूद है
            ),
          ],
        ),
      ),
    );
  }

  // आपके शेयर किए गए "No item found" कार्टून लेआउट जैसा सुंदर विजेट
  Widget _buildEmptyCartoonState(ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // कार्टून इलस्ट्रेशन का रिप्लेसमेंट आइकॉनिक डिज़ाइन
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_rounded,
                size: 80,
                color: theme.colorScheme.primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Content Found',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Admin has not uploaded any items in this category yet. When data is uploaded, it will appear right here!',
              textAlign.Center,
              style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  // ई-बुक सीरीज और नोट्स की सुंदर लिस्ट विजेट (Notes List UI)
  Widget _buildNotesList(List<Map<String, dynamic>> notes, ThemeData theme, bool isDark) {
    return ListView.builder(
      itemCount: notes.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemBuilder: (context, index) {
        final note = notes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 24),
            ),
            title: Text(
              note['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${note['course']} • ${note['class']}',
                      style: TextStyle(color: theme.colorScheme.primary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    note['size'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            // दाईं तरफ छोटा तीर और डाउनलोड बटन एक्शन आइकॉन
            trailing: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.primary, size: 14),
            ),
            onTap: () {
              // डाउनलोड या ऑनलाइन व्यू एक्शन ट्रिगर
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${note['title']} online safely...'),
                  backgroundColor: theme.colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
