import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  // सभी इनपुट बॉक्स के कंट्रोलर्स
  final _nameController = TextEditingController();
  final _fatherController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentPhoneController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _classController = TextEditingController();
  final _schoolController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  // कोर्सेज की लिस्ट
  final List<String> _courses = ['NVS', 'Sainik School', 'CHS'];
  String? _selectedCourse;

  @override
  void dispose() {
    _nameController.dispose();
    _fatherController.dispose();
    _emailController.dispose();
    _studentPhoneController.dispose();
    _parentPhoneController.dispose();
    _classController.dispose();
    _schoolController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // इनपुट बॉक्स को सुंदर डिजाइन देने के लिए हेल्पर मेथड
  InputDecoration _buildInputDecoration(String hint, IconData icon, ThemeData theme) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: theme.colorScheme.primary),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Account',
          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SUCCESS COACHING CENTRE',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),

                        // 1. छात्र का नाम
                        TextFormField(
                          controller: _nameController,
                          decoration: _buildInputDecoration('Full Name', Icons.person_outline, theme),
                        ),
                        const SizedBox(height: 16),

                        // 2. पिता का नाम
                        TextFormField(
                          controller: _fatherController,
                          decoration: _buildInputDecoration("Father's Name", Icons.supervisor_account_outlined, theme),
                        ),
                        const SizedBox(height: 16),

                        // 3. ईमेल एड्रेस
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _buildInputDecoration('Email Address (For Verification)', Icons.email_outlined, theme),
                        ),
                        const SizedBox(height: 16),

                        // 4. छात्र का मोबाइल नंबर
                        TextFormField(
                          controller: _studentPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _buildInputDecoration('Student Mobile Number', Icons.phone_android_rounded, theme),
                        ),
                        const SizedBox(height: 16),

                        // 5. गार्जियन का मोबाइल नंबर
                        TextFormField(
                          controller: _parentPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _buildInputDecoration('Parent Mobile Number', Icons.phone_enabled_rounded, theme),
                        ),
                        const SizedBox(height: 16),

                        // 6. कक्षा (Class)
                        TextFormField(
                          controller: _classController,
                          decoration: _buildInputDecoration('Class', Icons.class_outlined, theme),
                        ),
                        const SizedBox(height: 16),

                        // 7. स्कूल का नाम
                        TextFormField(
                          controller: _schoolController,
                          decoration: _buildInputDecoration('School Name', Icons.school_outlined, theme),
                        ),
                        const SizedBox(height: 16),

                        // 8. पूरा पता
                        TextFormField(
                          controller: _addressController,
                          decoration: _buildInputDecoration('Full Address', Icons.home_outlined, theme),
                        ),
                        const SizedBox(height: 16),

                        // 9. कोर्स सिलेक्शन ड्रॉपडाउन
                        DropdownButtonFormField<String>(
                          value: _selectedCourse,
                          hint: Text('Select Course', style: TextStyle(color: Colors.grey.shade600)),
                          decoration: _buildInputDecoration('Selected Course', Icons.assignment_outlined, theme),
                          items: _courses.map((String course) {
                            return DropdownMenuItem<String>(
                              value: course,
                              child: Text(course),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCourse = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // 10. पासवर्ड
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: _buildInputDecoration('Password', Icons.lock_outline, theme).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // रजिस्टर बटन
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text('Verify Your Email'),
                                  content: Text('A verification link will be sent to ${_emailController.text}. Please check your inbox.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'REGISTER & VERIFY',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}