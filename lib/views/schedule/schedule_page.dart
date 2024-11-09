import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/common/extensions/date_format_ext.dart';
import 'package:vetpro/controller/calendar_controller.dart';
import 'package:vetpro/data/datasources/schedule_remote_datasource.dart';
import 'package:vetpro/views/schedule/create_schedule_page.dart';
import 'package:vetpro/views/schedule/detail_schedule_page.dart';
import 'package:vetpro/views/schedule/edit_schedule_page.dart';

import '../../bloc/schedule/schedule_bloc.dart';
import '../../common/components/list_card_widget.dart';
import '../../common/components/tab_menu_widget.dart';
import '../../data/models/schedule_response_model.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  Future<void> _autoDeleteSchedules(List<Schedule> schedules) async {
    final DateTime currentDate = DateTime.now();

    // Find schedules that have inspection dates in the past
    final List<Schedule> expiredSchedules = schedules
        .where((schedule) => DateTime.parse(schedule.inspectionDate.toString())
            .isBefore(currentDate))
        .toList();

    // Delete past schedules from the list
    for (final expiredSchedule in expiredSchedules) {
      if (DateTime.parse(expiredSchedule.inspectionDate.toString())
              .isBefore(currentDate) &&
          DateTime.parse(expiredSchedule.inspectionDate.toString()).day !=
              currentDate.day) {
        final deleteResponse = await ScheduleRemoteDatasource()
            .deleteSchedule(expiredSchedule.id!);
        deleteResponse.fold(
          (error) => print(
              'Error deleting schedule with id ${expiredSchedule.id}: $error'),
          (success) => print(
              'Schedule with id ${expiredSchedule.id} deleted successfully.'),
        );
      }
    }
  }

  //filter date
  List<Schedule> sortByInspectionDate(List<Schedule> schedules) {
    schedules.sort((a, b) {
      final DateTime dateA = DateTime.parse(a.inspectionDate.toString());
      final DateTime dateB = DateTime.parse(b.inspectionDate.toString());
      return dateB.compareTo(dateA);
    });
    return schedules;
  }

  @override
  void initState() {
    context.read<ScheduleBloc>().add(const ScheduleEvent.getSchedule());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final calendarC = Get.put(CalendarController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondaryColor,
        title: const Text(''),
        elevation: 0,
        actions: const [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.search,
                size: 45,
                color: Colors.black,
              ))
        ],
      ),
      body: ListView(
        children: [
          Container(
              decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: calendarC.buildDefaultSingleDatePickerWithValue()),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, top: 25, right: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Schedules',
                        style: blackTextStyle.copyWith(
                            fontSize: 18, fontWeight: bold),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const CreateSchedulePage();
                                },
                              ),
                            );
                          },
                          child: Image.asset('assets/add.png'))
                    ],
                  ),
                ),
                BlocBuilder<ScheduleBloc, ScheduleState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: primaryColor,
                          ),
                        );
                      },
                      loadedGet: (model) {
                        _autoDeleteSchedules(model.data);
                        sortByInspectionDate(model.data);
                        if (model.data!.isEmpty) {
                          return Container(
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                            height: 500,
                            child: Center(
                              child: Text(
                                'Tidak data schedule yang tersedia.',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: bold,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: model.data!.length,
                            itemBuilder: (context, index) {
                              return ListCardWidget(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return DetailSchedulePage(
                                            schedule: model.data![index]);
                                      },
                                    ),
                                  );
                                },
                                color: secondaryColor,
                                flag: '2',
                                text1: model.data![index].animalName!,
                                text2: model.data![index].location!,
                                text3: model.data![index].inspector!,
                                text4: DateTime.parse(model
                                        .data![index].inspectionDate
                                        .toString())
                                    .formatDate(),
                                widget: const Center(
                                  child: Icon(
                                    Icons.edit_rounded,
                                    color: blackColor,
                                  ),
                                ),
                                onPressed: () => Get.to(
                                  EditSchedulePage(
                                    schedule: model.data![index],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const TabMenuWidget(menu: '3'),
    );
  }
}
