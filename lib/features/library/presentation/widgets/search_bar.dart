import 'package:flutter/material.dart';
import 'package:hephzibah/core/theme/color_scheme.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback onSearch;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = "Search...",
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search, color: Colors.grey),
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
