// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vetpro/bloc/schedule/schedule_bloc.dart';
import 'package:vetpro/common/extensions/date_format_ext.dart';
import 'package:vetpro/data/models/schedule_response_model.dart';
import 'package:vetpro/views/schedule/edit_schedule_page.dart';
import 'package:vetpro/views/schedule/schedule_page.dart';

import '../../common/components/form.dart';
import '../../common/constants/colors.dart';
import '../../common/constants/theme.dart';

class DetailSchedulePage extends StatelessWidget {
  final Schedule schedule;
  const DetailSchedulePage({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detail Schedule',
          style: whiteTextStyle,
        ),
        actions: [
          BlocConsumer<ScheduleBloc, ScheduleState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                loadedDelete: (data) {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return const SchedulePage();
                  }), (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: greenColor,
                      content: Text('Delete Schedule Success'),
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
                  return IconButton(
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: whiteColor,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Schedule'),
                            content: const Text(
                                'Are you sure for delete this schedule?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: secondaryTextStyle,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<ScheduleBloc>().add(
                                      ScheduleEvent.deleteSchedule(
                                          schedule.id!));
                                },
                                child: Text(
                                  'Delete',
                                  style: secondaryTextStyle,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                loading: () {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        color: whiteColor,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
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
              initialValue: schedule.animalName,
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
              initialValue: DateTime.parse(schedule.inspectionDate.toString())
                  .formatDate(),
              title: 'Tanggal Pemeriksaan',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              initialValue: schedule.location,
              title: 'Lokasi',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              initialValue: schedule.inspector,
              title: 'Nama Pemeriksa',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              initialValue: schedule.description,
              title: 'Deskripsi',
              fillColor: Colors.white,
              maxLine: 6,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EditSchedulePage(
                  schedule: schedule,
                );
              },
            ),
          );
        },
        backgroundColor: secondaryColor,
        child: const Icon(
          Icons.edit_rounded,
          color: whiteColor,
        ),
      ),
    );
  }
}
