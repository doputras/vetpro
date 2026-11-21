import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';

/// Labelled text field. Fields are flat (no shadow): raised things are
/// pressable, flat things are typed into.
class CustomFormField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String? hintText;
  final int maxLine;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  const CustomFormField({
    super.key,
    required this.title,
    this.controller,
    this.hintText,
    this.maxLine = 1,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: labelStyle),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          obscureText: obscureText,
          minLines: maxLine > 1 ? 2 : 1,
          maxLines: obscureText ? 1 : maxLine,
          keyboardType: maxLine > 1 ? TextInputType.multiline : keyboardType,
          textInputAction: textInputAction,
          textCapitalization: maxLine > 1
              ? TextCapitalization.sentences
              : TextCapitalization.none,
          inputFormatters: inputFormatters,
          autofillHints: autofillHints,
          style: bodyStyle.copyWith(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            prefixText: prefixText,
            prefixStyle: bodyStyle.copyWith(
                color: mutedColor, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

/// A titled sticker card that groups related fields.
class FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const FormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Sticker(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: tealSoftColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: inkColor, width: 1.5),
                  ),
                  child: Icon(icon, size: 18, color: inkColor),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: displayStyle(18))),
              ],
            ),
            for (final child in children) ...[
              const SizedBox(height: 14),
              child,
            ],
          ],
        ),
      ),
    );
  }
}

/// Read-only label/value pair for detail screens.
class InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  const InfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    final v = (value == null || value!.trim().isEmpty) ? '—' : value!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: mutedStyle.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(v, style: bodyStyle),
        ],
      ),
    );
  }
}
