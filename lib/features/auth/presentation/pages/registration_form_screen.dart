// lib/features/auth/presentation/pages/registration_form_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/auth/domain/models/registration_request_model.dart';
import 'package:hephzibah/features/auth/presentation/providers/auth_provider.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AbsorbPointer(
          absorbing: isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _firstName,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _lastName,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _age,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: 'M', child: Text('Male')),
                    DropdownMenuItem(value: 'F', child: Text('Female')),
                  ],
                  onChanged: (val) => setState(() => _gender = val!),
                ),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value!.length < 6 ? 'Min 6 characters' : null,
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Email (optional)',
                  ),
                ),
                TextFormField(
                  controller: _church,
                  decoration: const InputDecoration(
                    labelText: 'Church (optional)',
                  ),
                ),
                TextFormField(
                  controller: _location,
                  decoration: const InputDecoration(
                    labelText: 'Location (optional)',
                  ),
                ),
                TextFormField(
                  controller: _occupation,
                  decoration: const InputDecoration(
                    labelText: 'Occupation (optional)',
                  ),
                ),
                TextFormField(
                  controller: _bio,
                  decoration: const InputDecoration(
                    labelText: 'Bio (optional)',
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Register'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
