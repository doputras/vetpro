import 'package:flutter/material.dart';

import 'package:vetpro/common/components/form.dart';

import '../../../common/constants/colors.dart';

class ChooseAnimalWidget extends StatefulWidget {
  final String title;
  String? selectedAnimal;
  String? otherAnimal;
  //final TextEditingController? controller;
  ChooseAnimalWidget({
    Key? key,
    required this.title,
    this.selectedAnimal,
    this.otherAnimal,
    //this.controller,
  }) : super(key: key);

  @override
  _ChooseAnimalWidgetState createState() => _ChooseAnimalWidgetState();
}

class _ChooseAnimalWidgetState extends State<ChooseAnimalWidget> {
  // String selectedAnimal = 'Domba';
  // String otherAnimal = '';
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
                  blurRadius: 4, // level shadow
                  offset: const Offset(0, 6), // Offset shadow (x, y)
                ),
              ],
              borderRadius: BorderRadius.circular(30)),
          child: DropdownButtonFormField<String>(
            value: widget.selectedAnimal,
            onChanged: (String? newValue) {
              setState(() {
                widget.selectedAnimal = newValue!;
                if (widget.selectedAnimal != 'Lainnya') {
                  widget.otherAnimal = '';
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

        if (widget.selectedAnimal == 'Lainnya')
          Column(
            children: [
              const SizedBox(
                height: 11,
              ),
              CustomFormField(
                onChanged: (value) {
                  setState(() {
                    widget.otherAnimal = value;
                  });
                },
                title: 'Tulis nama hewan',
                fillColor: Colors.white,
                maxLine: 2,
                //controller: widget.controller,
              ),
            ],
          ),
        // ElevatedButton(
        //   onPressed: () {
        //     if (selectedAnimal == 'Lainnya') {
        //       // Use otherAnimal variable for the input
        //       print('Hewan baru: $otherAnimal');
        //     } else {
        //       // Use selectedAnimal variable for the input
        //       print('Hewan dipilih: $selectedAnimal');
        //     }
        //   },
        //   child: const Text('Submit'),
        // ),
      ],
    );
  }
}
