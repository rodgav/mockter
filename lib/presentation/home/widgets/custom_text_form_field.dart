import 'dart:math';

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController customController;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final double paddingVertical;

  const CustomTextFormField(this.customController,
      {this.minLines,
      this.maxLines,
      this.keyboardType,
      this.paddingVertical = 4,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: customController,
      decoration: customInputDecoration(paddingVertical: paddingVertical),
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}

customInputDecoration({double paddingVertical = 4}) => InputDecoration(
      filled: true,
      contentPadding:
          EdgeInsets.symmetric(vertical: paddingVertical, horizontal: 6),
      fillColor: Colors.grey.shade200,
      focusColor: Colors.grey.shade200,
      hoverColor: Colors.grey.shade200,
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
    );
