import 'package:flutter/material.dart';
import 'package:vetpro/common/components/species.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';

/// Shared frame for login/register: sticker pile, headline, form card.
class AuthLayout extends StatelessWidget {
  final String lead;
  final String highlight;
  final String subtitle;
  final List<Widget> form;
  final Widget footer;

  const AuthLayout({
    super.key,
    required this.lead,
    required this.highlight,
    required this.subtitle,
    required this.form,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: _StickerPile()),
                    const SizedBox(height: 18),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(text: '$lead\n'),
                        TextSpan(
                          text: highlight,
                          style: const TextStyle(color: primaryColor),
                        ),
                      ]),
                      style: displayStyle(38),
                    ),
                    const SizedBox(height: 8),
                    Text(subtitle,
                        style: bodyStyle.copyWith(color: mutedColor)),
                    const SizedBox(height: 22),
                    Sticker(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: form,
                      ),
                    ),
                    const SizedBox(height: 12),
                    footer,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The species, slapped on like stickers around the app mark.
class _StickerPile extends StatelessWidget {
  const _StickerPile();

  static const _spots = [
    // animal, left, top, size, tilt
    ('Domba', 18.0, 18.0, 64.0, -0.22),
    ('Rusa', 196.0, 6.0, 60.0, 0.18),
    ('Kelinci', 0.0, 104.0, 56.0, 0.14),
    ('Angsa', 212.0, 98.0, 58.0, -0.16),
    ('Burung', 128.0, 132.0, 46.0, 0.3),
  ];

  @override
  Widget build(BuildContext context) {
    final noMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    Widget pop(int i, Widget child) => noMotion
        ? child
        : TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 380 + i * 70),
            curve: Curves.easeOutQuart,
            builder: (_, t, c) =>
                Transform.scale(scale: 0.7 + 0.3 * t, child: c),
            child: child,
          );

    return SizedBox(
      width: 272,
      height: 184,
      child: Stack(
        children: [
          for (var i = 0; i < _spots.length; i++)
            Positioned(
              left: _spots[i].$2,
              top: _spots[i].$3,
              child: pop(
                i + 1,
                SpeciesSticker(
                  animal: _spots[i].$1,
                  size: _spots[i].$4,
                  tilt: _spots[i].$5,
                ),
              ),
            ),
          Positioned(
            left: 92,
            top: 34,
            child: pop(0, const VetproMark(size: 92)),
          ),
        ],
      ),
    );
  }
}

/// Inline error box: errors sit next to the form, not in a pop-up.
class FormError extends StatelessWidget {
  final String message;
  const FormError(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: errorSoftColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
              child: Text(message,
                  style: bodyStyle.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
