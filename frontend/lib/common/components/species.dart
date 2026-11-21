import 'package:flutter/material.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';

/// Each species owns a sticker + color that follows it through the app.
class Species {
  final String name;
  final String asset;
  final Color color;
  const Species(this.name, this.asset, this.color);
}

const List<Species> speciesList = [
  Species('Domba', 'assets/domba.png', Color(0xFFFFE08A)),
  Species('Rusa', 'assets/rusa.png', Color(0xFFF7A867)),
  Species('Angsa', 'assets/angsa.png', Color(0xFFA6D8F2)),
  Species('Burung', 'assets/burung.png', Color(0xFFB4E09B)),
  Species('Kelinci', 'assets/kelinci.png', Color(0xFFF8B8C8)),
  Species('Lainnya', 'assets/lainnya.png', Color(0xFFCDBDF4)),
];

/// Free-text animals ("Lainnya") fall back to the last entry.
Species speciesFor(String? animal) {
  final key = animal?.trim().toLowerCase();
  return speciesList.firstWhere(
    (s) => s.name.toLowerCase() == key,
    orElse: () => speciesList.last,
  );
}

/// Die-cut sticker: ink outline, white cut ring, species color, line icon.
class SpeciesSticker extends StatelessWidget {
  final String? animal;
  final double size;
  final double tilt;

  const SpeciesSticker({
    super.key,
    required this.animal,
    this.size = 52,
    this.tilt = 0,
  });

  @override
  Widget build(BuildContext context) {
    final s = speciesFor(animal);
    final sticker = Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.06),
      decoration: BoxDecoration(
        color: whiteColor,
        shape: BoxShape.circle,
        border: Border.all(color: inkColor, width: size > 70 ? 2.5 : 2),
      ),
      child: Container(
        decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
        padding: EdgeInsets.all(size * 0.17),
        child: Image.asset(s.asset, color: inkColor, fit: BoxFit.contain),
      ),
    );
    return Semantics(
      label: s.name,
      child:
          tilt == 0 ? sticker : Transform.rotate(angle: tilt, child: sticker),
    );
  }
}

/// Colored hero card keyed to the species, used by detail screens.
class SpeciesHeader extends StatelessWidget {
  final String? animal;
  final String title;
  final String subtitle;
  final List<(IconData, String)> chips;

  const SpeciesHeader({
    super.key,
    required this.animal,
    required this.title,
    required this.subtitle,
    this.chips = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Sticker(
      color: speciesFor(animal).color,
      radius: 24,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SpeciesSticker(animal: animal, size: 72, tilt: -0.08),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: displayStyle(28)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style:
                            labelStyle.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (icon, text) in chips)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: inkColor, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16, color: inkColor),
                        const SizedBox(width: 4),
                        Text(text, style: labelStyle.copyWith(fontSize: 13)),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
