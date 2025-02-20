import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObstureText;
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObstureText = false
    });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (val) {
        if (val!.trim().isEmpty) {
          return '$hintText cannot be empty';
        }
        return null;
      },
      obscureText: isObstureText,
    );
  }
}