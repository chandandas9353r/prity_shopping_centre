import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Color? color;
  const Button({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color ?? Colors.green.shade400,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Function(String value) onChange;
  const CustomTextField({
    super.key,
    required this.hint,
    required this.focusNode,
    required this.onChange,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: TextFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15.0),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(),
            hintText: hint,
          ),
          focusNode: focusNode,
          keyboardType: keyboardType ?? TextInputType.text,
          onChanged: onChange,
        ),
      ),
    );
  }
}