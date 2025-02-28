import 'package:flutter/material.dart';
import 'package:vetpro/common/components/form.dart';
import '../../../common/constants/colors.dart';

class ChooseAnimalWidget extends StatefulWidget {
  final String title;

  const ChooseAnimalWidget({
    super.key,
    required this.title,
  });

  @override
  ChooseAnimalWidgetState createState() => ChooseAnimalWidgetState();
}

class ChooseAnimalWidgetState extends State<ChooseAnimalWidget> {
  String? selectedAnimal;
  String? otherAnimal;

  final animals = [
    'Domba',
    'Rusa',
    'Angsa',
    'Burung',
    'Kelinci',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          width: double.infinity,
          height: 80,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: greyColor.withOpacity(0.8), // shadow color
                spreadRadius: -1, // shadow width
                blurRadius: 4, // shadow blur level
                offset: const Offset(0, 6), // Offset shadow (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedAnimal,
            onChanged: (String? newValue) {
              setState(() {
                selectedAnimal = newValue;
                if (selectedAnimal != 'Lainnya') {
                  otherAnimal = '';
                }
              });
            },
            items: animals.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              helperMaxLines: 2,
              filled: true,
              isDense: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
        ),

        if (selectedAnimal == 'Lainnya')
          Column(
            children: [
              const SizedBox(
                height: 11,
              ),
              CustomFormField(
                onChanged: (value) {
                  setState(() {
                    otherAnimal = value;
                  });
                },
                title: 'Tulis nama hewan',
                fillColor: Colors.white,
                maxLine: 2,
              ),
            ],
          ),
      ],
    );
  }
}
