import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetpro/bloc/schedule/schedule_bloc.dart';
import 'package:vetpro/common/components/buttons.dart';
import 'package:vetpro/data/models/schedule_request_model.dart';
import 'package:vetpro/views/schedule/schedule_page.dart';

import '../../common/components/form.dart';
import '../../common/constants/colors.dart';
import '../../common/constants/theme.dart';

class CreateSchedulePage extends StatefulWidget {
  const CreateSchedulePage({super.key});

  @override
  State<CreateSchedulePage> createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController inspectorController = TextEditingController();
  final TextEditingController animalController = TextEditingController();
  final TextEditingController inspectionDateController =
      TextEditingController();

  @override
  void dispose() {
    locationController.dispose();
    inspectorController.dispose();
    animalController.dispose();
    inspectionDateController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Create Schedule',
          style: whiteTextStyle,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 231, 229, 229),
            borderRadius: BorderRadius.circular(15)),
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          children: [
            CustomFormField(
              controller: animalController,
              title: 'Hewan',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            // ChooseAnimalWidget(
            //   title: 'Pilih hewan',
            //   selectedAnimal: selectedItem,
            //   otherAnimal: otherItem,
            //   //controller: animalController,
            // ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              readOnly: true,
              controller: inspectionDateController,
              title: 'Tanggal Pemeriksaan',
              fillColor: Colors.white,
              maxLine: 2,
              onTap: () async {
                await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2015),
                  lastDate: DateTime(2025),
                  initialDatePickerMode: DatePickerMode.day,
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme:
                            const ColorScheme.light(primary: secondaryColor),
                        buttonTheme: const ButtonThemeData(
                            textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    );
                  },
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                      inspectionDateController.text = selectedDate.toString();
                    });
                  }
                });
              },
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              controller: locationController,
              title: 'Lokasi',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              controller: inspectorController,
              title: 'Nama Pemeriksa',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              controller: descriptionController,
              title: 'Deskripsi',
              fillColor: Colors.white,
              maxLine: 6,
            ),
            const SizedBox(
              height: 40,
            ),
            BlocConsumer<ScheduleBloc, ScheduleState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  loadedCreate: (data) {
                    //Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return const SchedulePage();
                    }), (route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: greenColor,
                        content: Text('Add Schedule Success'),
                      ),
                    );
                  },
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: secondaryColor,
                        content: Text(message),
                      ),
                    );
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return CustomFilledButton(
                      title: 'Add Schedule',
                      borderRadius: 20,
                      onPressed: () {
                        final dataModel = ScheduleRequestModel(
                          animalName: animalController.text,
                          inspectionDate:
                              DateTime.parse(inspectionDateController.text),
                          location: locationController.text,
                          inspector: inspectorController.text,
                          description: descriptionController.text,
                        );

                        context
                            .read<ScheduleBloc>()
                            .add(ScheduleEvent.createSchedule(dataModel));
                      },
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
