import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  final Function(String) onSaved;
  final String? Function(String?)? validator;
  final String? placeholder;

  const PasswordTextFormField({
    super.key,
    required this.onSaved,
    this.validator,
    this.placeholder,
  });

  @override
  _PasswordTextFormFieldState createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      obscureText: !_isPasswordVisible,
      validator: widget.validator ?? (value) => value != null && value.length < 6 ? 'Password too short.' : null,
      onSaved: (value) => widget.onSaved(value ?? ''),
      decoration: InputDecoration(
        labelText: widget.placeholder ?? 'Password',
        suffixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: _togglePasswordVisibility,
        ),
      ),
    );
  }
}
