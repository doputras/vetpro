import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/bloc/schedule/schedule_bloc.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/schedule_request_model.dart';
import 'package:vetpro/data/models/schedule_response_model.dart';
import 'package:vetpro/views/animal_inpection/widgets/choose_animal_widget.dart';
import 'package:vetpro/views/schedule/schedule_page.dart';

/// Create a schedule, or edit [schedule] when given.
class ScheduleFormPage extends StatefulWidget {
  final Schedule? schedule;
  final DateTime? initialDate;
  const ScheduleFormPage({super.key, this.schedule, this.initialDate});

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  late final Schedule? _edit = widget.schedule;
  late DateTime _date = DateUtils.dateOnly(
      _edit?.inspectionDate ?? widget.initialDate ?? DateTime.now());

  late final descriptionController =
      TextEditingController(text: _edit?.description ?? '');
  late final locationController =
      TextEditingController(text: _edit?.location ?? '');
  late final inspectorController =
      TextEditingController(text: _edit?.inspector ?? '');
  late final dateController = TextEditingController(text: _date.formatDate());
  final GlobalKey<ChooseAnimalWidgetState> _chooseAnimalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (_edit == null) {
      AuthLocalDatasource().getName().then((n) {
        if (mounted && inspectorController.text.isEmpty) {
          inspectorController.text = n ?? '';
        }
      });
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    locationController.dispose();
    inspectorController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = DateTime(2015);
    final last = DateTime(now.year + 3, 12, 31);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(first) || _date.isAfter(last) ? now : _date,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        dateController.text = picked.formatDate();
      });
    }
  }

  void _submit() {
    final animal = _chooseAnimalKey.currentState?.animalName;
    if (animal == null || animal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih dulu hewan yang akan diperiksa.')),
      );
      return;
    }
    final model = ScheduleRequestModel(
      animalName: animal,
      inspectionDate: _date,
      location: locationController.text,
      inspector: inspectorController.text,
      description: descriptionController.text,
    );
    final edit = _edit;
    context.read<ScheduleBloc>().add(edit == null
        ? ScheduleEvent.createSchedule(model)
        : ScheduleEvent.updateSchedule(edit.id!, model));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          stickerAppBar(context, _edit == null ? 'Jadwal baru' : 'Ubah jadwal'),
      // Not a lazy ListView: off-screen sections (like the species picker)
      // must stay alive or their state is lost while scrolling.
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormSection(
              title: 'Hewan apa?',
              icon: Icons.pets,
              children: [
                ChooseAnimalWidget(
                  key: _chooseAnimalKey,
                  initialAnimal: _edit?.animalName,
                ),
              ],
            ),
            FormSection(
              title: 'Detail jadwal',
              icon: Icons.event_note_rounded,
              children: [
                CustomFormField(
                  title: 'Tanggal pemeriksaan',
                  controller: dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  suffixIcon: const Icon(Icons.calendar_month_rounded),
                ),
                CustomFormField(
                  title: 'Lokasi',
                  hintText: 'mis. Kandang Rusa',
                  controller: locationController,
                  textInputAction: TextInputAction.next,
                ),
                CustomFormField(
                  title: 'Nama pemeriksa',
                  controller: inspectorController,
                  textInputAction: TextInputAction.next,
                ),
                CustomFormField(
                  title: 'Catatan',
                  hintText: 'Apa yang perlu dicek?',
                  controller: descriptionController,
                  maxLine: 4,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: backgroundColor,
            border: Border(top: inkBorder),
          ),
          child: BlocConsumer<ScheduleBloc, ScheduleState>(
            listener: (context, state) {
              void done(String message) {
                Get.offAll(() => const SchedulePage());
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }

              state.maybeWhen(
                orElse: () {},
                loadedCreate: (_) => done('Jadwal tersimpan!'),
                loadedUpdate: (_) => done('Perubahan tersimpan!'),
                error: (message) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menyimpan: $message')),
                ),
              );
            },
            builder: (context, state) => StickerButton(
              label: _edit == null ? 'Simpan jadwal' : 'Simpan perubahan',
              icon: Icons.check_rounded,
              loading:
                  state.maybeWhen(loading: () => true, orElse: () => false),
              onPressed: _submit,
            ),
          ),
        ),
      ),
    );
  }
}
