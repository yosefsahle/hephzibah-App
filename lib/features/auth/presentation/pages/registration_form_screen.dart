// lib/features/auth/presentation/pages/registration_form_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/auth/domain/models/registration_request_model.dart';
import 'package:hephzibah/features/auth/presentation/providers/auth_provider.dart';
import 'package:hephzibah/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationFormScreen extends ConsumerStatefulWidget {
  final String phone; // from verified OTP

  const RegistrationFormScreen({super.key, required this.phone});

  @override
  ConsumerState<RegistrationFormScreen> createState() =>
      _RegistrationFormScreenState();
}

class _RegistrationFormScreenState
    extends ConsumerState<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _age = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _church = TextEditingController();
  final _location = TextEditingController();
  final _occupation = TextEditingController();
  final _bio = TextEditingController();
  String _gender = 'M';

  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _profileImage = File(file.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = RegistrationRequest(
      firstName: _firstName.text,
      lastName: _lastName.text,
      age: int.parse(_age.text),
      gender: _gender,
      phoneNumber: widget.phone,
      password: _password.text,
      email: _email.text.isEmpty ? null : _email.text,
      church: _church.text.isEmpty ? null : _church.text,
      location: _location.text.isEmpty ? null : _location.text,
      occupation: _occupation.text.isEmpty ? null : _occupation.text,
      bio: _bio.text.isEmpty ? null : _bio.text,
      profileImage: _profileImage,
    );

    try {
      await ref.read(authStateProvider.notifier).registerUser(request);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
        context.goNamed('login'); // Or go to home
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authStateProvider).isLoading;
    final fontsize = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration Form',
          style: TextStyle(fontSize: fontsize.titleMedium?.fontSize),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AbsorbPointer(
          absorbing: isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.add_a_photo, size: 32)
                        : null,
                  ),
                ),
                const Text('Tap to select profile image'),
                const SizedBox(height: 30),
                customTextFormFieldFn(
                  controller: _firstName,
                  labelText: 'First Name',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                customTextFormFieldFn(
                  controller: _lastName,
                  labelText: 'Last Name',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                customTextFormFieldFn(
                  controller: _age,
                  labelText: 'Age',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                  keyboardType: TextInputType.number,
                ),

                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: 'M', child: Text('Male')),
                    DropdownMenuItem(value: 'F', child: Text('Female')),
                  ],
                  onChanged: (val) => setState(() => _gender = val!),
                ),
                const SizedBox(height: 16),
                customTextFormFieldFn(
                  controller: _password,
                  labelText: 'Password',
                  obscureText: true,
                  validator: (value) =>
                      value!.length < 6 ? 'Min 6 characters' : null,
                ),
                customTextFormFieldFn(
                  controller: _email,
                  labelText: 'Email (optional)',
                ),
                customTextFormFieldFn(
                  controller: _church,
                  labelText: 'Church (optional)',
                ),
                customTextFormFieldFn(
                  controller: _location,
                  labelText: 'Location (optional)',
                ),
                customTextFormFieldFn(
                  controller: _occupation,
                  labelText: 'Occupation (optional)',
                ),
                customTextFormFieldFn(
                  controller: _bio,
                  labelText: 'Bio (optional)',
                ),

                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            55,
                          ), // Sets minimum width to 150 and height to 40
                        ),
                        onPressed: _submit,
                        child: const Text('Register'),
                      ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextFormFieldFn({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Key? key,
  }) {
    final isRequired = validator != null;

    Widget buildLabel() {
      if (!isRequired) {
        return Text(labelText);
      }

      return RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black54, fontSize: 16),
          children: [
            TextSpan(text: labelText),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    if (obscureText) {
      final visibilityNotifier = ValueNotifier<bool>(false);

      return ValueListenableBuilder<bool>(
        valueListenable: visibilityNotifier,
        builder: (context, isVisible, child) {
          return Padding(
            key: key,
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              controller: controller,
              // Text is obscured if isVisible is false
              obscureText: !isVisible,
              decoration: InputDecoration(
                label: buildLabel(),
                labelText: null, // Required when using 'label' property
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    // Toggling the value notifies the ValueListenableBuilder to rebuild only this widget
                    visibilityNotifier.value = !isVisible;
                  },
                ),
              ),
              validator: validator,
              keyboardType: TextInputType.visiblePassword,
            ),
          );
        },
      );
    }

    // --- Standard Text Field Handling (Stateless) ---
    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 16.0), // Consistent spacing
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: buildLabel(), // Use the consolidated label builder
          labelText: null, // Required when using 'label'
        ),
        validator: validator,
        keyboardType: keyboardType,
        obscureText: false,
      ),
    );
  }
}
