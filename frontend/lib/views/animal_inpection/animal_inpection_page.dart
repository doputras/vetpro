import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vetpro/bloc/inspection/inspection_bloc.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/inspection_model.dart';
import 'package:vetpro/views/animal_inpection/widgets/choose_animal_widget.dart';

class AnimalInpectionPage extends StatefulWidget {
  final String? initialAnimal;
  const AnimalInpectionPage({super.key, this.initialAnimal});

  @override
  State<AnimalInpectionPage> createState() => _AnimalInpectionPageState();
}

class _AnimalInpectionPageState extends State<AnimalInpectionPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? bytes;
  DateTime _date = DateUtils.dateOnly(DateTime.now());

  final TextEditingController reviewController = TextEditingController();
  final TextEditingController medicalController = TextEditingController();
  final TextEditingController cageController = TextEditingController();
  final TextEditingController eatController = TextEditingController();
  final TextEditingController scopeController = TextEditingController();
  final TextEditingController suggestionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController inspectorController = TextEditingController();
  late final TextEditingController dateController =
      TextEditingController(text: _date.formatDate());

  final GlobalKey<ChooseAnimalWidgetState> _chooseAnimalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // The person logged in is almost always the one inspecting.
    AuthLocalDatasource().getName().then((n) {
      if (mounted && inspectorController.text.isEmpty) {
        inspectorController.text = n ?? '';
      }
    });
  }

  @override
  void dispose() {
    for (final c in [
      reviewController,
      medicalController,
      cageController,
      eatController,
      scopeController,
      suggestionController,
      locationController,
      inspectorController,
      dateController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> getCamera() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 800.0,
        maxWidth: 460.0,
      );
      if (picked == null) return;
      final data = await picked.readAsBytes();
      if (mounted) setState(() => bytes = data);
    } catch (e) {
      debugPrint('Error picking image: $e');
      _toast('Kamera belum bisa dibuka. Coba lagi, ya.');
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        dateController.text = picked.formatDate();
      });
    }
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  void _submitForm() {
    final animal = _chooseAnimalKey.currentState?.animalName;
    if (animal == null || animal.isEmpty) {
      _toast('Pilih dulu hewan yang diperiksa.');
      return;
    }
    context.read<InspectionBloc>().add(InspectionEvent.addInspection(
          InspectionModel(
            animal: animal,
            cageTreatment: cageController.text,
            environmentalCare: scopeController.text,
            feeding: eatController.text,
            inspector: inspectorController.text,
            location: locationController.text,
            medicalTreatment: medicalController.text,
            suggestion: suggestionController.text,
            result: reviewController.text,
            date: DateFormat('yyyy-MM-dd').format(_date),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: stickerAppBar(context, 'Pemeriksaan baru'),
      // Not a lazy ListView: off-screen sections (like the species picker)
      // must stay alive or their state is lost while scrolling.
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormSection(
              title: 'Hewan apa yang diperiksa?',
              icon: Icons.pets,
              children: [
                ChooseAnimalWidget(
                  key: _chooseAnimalKey,
                  initialAnimal: widget.initialAnimal,
                ),
              ],
            ),
            FormSection(
              title: 'Kapan & di mana',
              icon: Icons.place_rounded,
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
                  hintText: 'mis. Kandang A',
                  controller: locationController,
                  textInputAction: TextInputAction.next,
                ),
                CustomFormField(
                  title: 'Nama pemeriksa',
                  controller: inspectorController,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
            FormSection(
              title: 'Hasil pemeriksaan',
              icon: Icons.monitor_heart_rounded,
              children: [
                CustomFormField(
                  title: 'Hasil pemeriksaan hewan',
                  hintText: 'Kondisi umum, gejala, suhu...',
                  controller: reviewController,
                  maxLine: 4,
                ),
                CustomFormField(
                  title: 'Perawatan medis',
                  hintText: 'Obat, dosis, tindakan',
                  controller: medicalController,
                  maxLine: 3,
                ),
              ],
            ),
            FormSection(
              title: 'Perawatan harian',
              icon: Icons.grass_rounded,
              children: [
                CustomFormField(
                  title: 'Perawatan kandang',
                  controller: cageController,
                  maxLine: 2,
                ),
                CustomFormField(
                  title: 'Pemberian makan',
                  controller: eatController,
                  maxLine: 2,
                ),
                CustomFormField(
                  title: 'Perawatan lingkungan',
                  controller: scopeController,
                  maxLine: 2,
                ),
              ],
            ),
            FormSection(
              title: 'Catatan & foto',
              icon: Icons.photo_camera_rounded,
              children: [
                CustomFormField(
                  title: 'Saran tambahan',
                  controller: suggestionController,
                  maxLine: 3,
                ),
                _PhotoField(bytes: bytes, onPick: getCamera),
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
          child: BlocConsumer<InspectionBloc, InspectionState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                loaded: (data) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Pemeriksaan ${data.animal} tersimpan!')),
                  );
                },
                error: (message) => _toast('Gagal menyimpan: $message'),
              );
            },
            builder: (context, state) => StickerButton(
              label: 'Simpan pemeriksaan',
              icon: Icons.check_rounded,
              loading:
                  state.maybeWhen(loading: () => true, orElse: () => false),
              onPressed: _submitForm,
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoField extends StatelessWidget {
  final Uint8List? bytes;
  final VoidCallback onPick;
  const _PhotoField({required this.bytes, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Foto bukti', style: labelStyle),
        const SizedBox(height: 6),
        if (bytes == null)
          Sticker(
            onTap: onPick,
            semanticLabel: 'Ambil foto',
            color: tealSoftColor,
            depth: 3,
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: Column(
              children: [
                const Icon(Icons.add_a_photo_rounded,
                    size: 32, color: inkColor),
                const SizedBox(height: 6),
                Text('Ambil foto', style: labelStyle),
                Text('Opsional', style: mutedStyle),
              ],
            ),
          )
        else ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: inkColor, width: 2),
              ),
              child: Image.memory(bytes!, height: 220, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 10),
          StickerButton(
            label: 'Ganti foto',
            icon: Icons.refresh_rounded,
            color: whiteColor,
            textColor: inkColor,
            compact: true,
            onPressed: onPick,
          ),
        ],
      ],
    );
  }
}
