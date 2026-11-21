import 'package:flutter/material.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/components/species.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';

/// Species picker: tap a sticker instead of opening a dropdown.
/// Read the result through a GlobalKey: [selectedAnimal] / [otherAnimal].
class ChooseAnimalWidget extends StatefulWidget {
  final String? initialAnimal;

  const ChooseAnimalWidget({super.key, this.initialAnimal});

  @override
  ChooseAnimalWidgetState createState() => ChooseAnimalWidgetState();
}

class ChooseAnimalWidgetState extends State<ChooseAnimalWidget> {
  String? selectedAnimal;
  String? otherAnimal;
  late final TextEditingController _other = TextEditingController();

  /// The animal name to save: the typed name when "Lainnya" is picked.
  String? get animalName =>
      selectedAnimal == 'Lainnya' ? otherAnimal?.trim() : selectedAnimal;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialAnimal?.trim();
    if (initial == null || initial.isEmpty) return;
    final known = speciesList.any((s) => s.name == initial);
    selectedAnimal = known ? initial : 'Lainnya';
    if (!known) {
      otherAnimal = initial;
      _other.text = initial;
    }
  }

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(builder: (context, c) {
          const gap = 10.0;
          final w = (c.maxWidth - gap * 2) / 3;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final s in speciesList)
                SizedBox(width: w, child: _chip(s, s.name == selectedAnimal)),
            ],
          );
        }),
        if (selectedAnimal == 'Lainnya') ...[
          const SizedBox(height: 14),
          CustomFormField(
            title: 'Nama hewannya',
            hintText: 'mis. Kambing',
            controller: _other,
            onChanged: (v) => otherAnimal = v,
          ),
        ],
      ],
    );
  }

  Widget _chip(Species s, bool selected) {
    final noMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return Semantics(
      button: true,
      selected: selected,
      label: s.name,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () => setState(() {
          selectedAnimal = s.name;
          if (s.name != 'Lainnya') otherAnimal = '';
        }),
        child: AnimatedContainer(
          duration:
              noMotion ? Duration.zero : const Duration(milliseconds: 160),
          curve: Curves.easeOutQuart,
          padding: const EdgeInsets.symmetric(vertical: 10),
          transform: Matrix4.translationValues(0, selected ? 3 : 0, 0),
          decoration: BoxDecoration(
            color: selected ? s.color : whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: inkColor, width: 2),
            boxShadow: [
              BoxShadow(color: inkColor, offset: Offset(0, selected ? 0 : 3)),
            ],
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SpeciesSticker(animal: s.name, size: 46),
                  if (selected)
                    Positioned(
                      right: -6,
                      top: -4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: inkColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: whiteColor, width: 2),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(Icons.check_rounded,
                            size: 14, color: whiteColor),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(s.name,
                  style: labelStyle.copyWith(
                      fontSize: 13, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}
