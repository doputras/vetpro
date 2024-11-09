import 'dart:io';
import 'dart:typed_data'; // Import for Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vetpro/bloc/inspection/inspection_bloc.dart';
import 'package:vetpro/bloc/inspection_invoice/inspection_invoice_bloc.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/models/inspection_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetpro/views/animal_inpection/widgets/choose_animal_widget.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class AnimalInpectionPage extends StatefulWidget {
  const AnimalInpectionPage({super.key});

  @override
  State<AnimalInpectionPage> createState() => _AnimalInpectionPageState();
}

class _AnimalInpectionPageState extends State<AnimalInpectionPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;
  File? tempFile;
  Uint8List? bytes;

  final TextEditingController reviewController = TextEditingController();
  final TextEditingController medicalController = TextEditingController();
  final TextEditingController cageController = TextEditingController();
  final TextEditingController eatController = TextEditingController();
  final TextEditingController scopeController = TextEditingController();
  final TextEditingController suggestionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController inspectorController = TextEditingController();
  final TextEditingController createdAtController = TextEditingController();

  final GlobalKey<ChooseAnimalWidgetState> _chooseAnimalKey = GlobalKey();

  Future<void> getCamera() async {
    try {
      pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 800.0,
        maxWidth: 460.0,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        setState(() {
          tempFile = File(pickedFile!.path);
          bytes = tempFile!.readAsBytesSync();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Function to show DatePicker and set the selected date to the controller
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        createdAtController.text = DateFormat('yyyy-MM-dd').format(picked); // Format date as needed
      });
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    medicalController.dispose();
    cageController.dispose();
    eatController.dispose();
    scopeController.dispose();
    suggestionController.dispose();
    locationController.dispose();
    inspectorController.dispose();
    createdAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Animal Inspection',
          style: whiteTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 229, 229),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                children: [
                  CustomFormField(
                    controller: reviewController,
                    title: 'Hasil pemeriksaan hewan',
                    fillColor: Colors.white,
                    maxLine: 3,
                  ),
                  const SizedBox(height: 11),
                  ChooseAnimalWidget(
                    key: _chooseAnimalKey,
                    title: 'Pilih Hewan',
                  ),
                  const SizedBox(height: 11),
                  GestureDetector(
                    onTap: () => _selectDate(context), // Show date picker on tap
                    child: AbsorbPointer( // Prevents keyboard from appearing
                      child: CustomFormField(
                        controller: createdAtController,
                        title: 'Tanggal pemeriksaan',
                        fillColor: Colors.white,
                        maxLine: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  CustomFormField(
                    controller: medicalController,
                    title: 'Perawatan medis',
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 11),
                  CustomFormField(
                    controller: cageController,
                    title: 'Perawatan kandang',
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 11),
                  CustomFormField(
                    controller: eatController,
                    title: 'Pemberian makan',
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 11),
                  CustomFormField(
                    controller: scopeController,
                    title: 'Perawatan lingkungan',
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 11),
                  CustomFormField(
                    controller: suggestionController,
                    title: 'Saran tambahan',
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 11),
                  CustomFormField(
                    controller: locationController,
                    title: 'Lokasi',
                    fillColor: Colors.white,
                    maxLine: 1,
                  ),
                  const SizedBox(height: 11),
                  CustomFormField(
                    controller: inspectorController,
                    title: 'Nama Pemeriksa',
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 11),
                  const Text(
                    'Bukti Gambar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  // Image display area
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: greyColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                      image: tempFile != null
                          ? DecorationImage(
                              image: FileImage(tempFile!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: tempFile == null
                        ? const Center(
                            child: Icon(Icons.image, color: whiteColor, size: 32),
                          )
                        : null,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: getCamera,
                    child: const Text("Add Photo"),
                  ),
                  const SizedBox(height: 30),
                  BlocConsumer<InspectionBloc, InspectionState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return InkWell(
                            onTap: () {
                              final selectedAnimal =
                                  _chooseAnimalKey.currentState?.selectedAnimal == 'Lainnya'
                                      ? _chooseAnimalKey.currentState?.otherAnimal
                                      : _chooseAnimalKey.currentState?.selectedAnimal;

                              final dataModel = InspectionModel(
                                animal: selectedAnimal ?? '',
                                cageTreatment: cageController.text,
                                environmentalCare: scopeController.text,
                                feeding: eatController.text,
                                inspector: inspectorController.text,
                                location: locationController.text,
                                medicalTreatment: medicalController.text,
                                suggestion: suggestionController.text,
                                result: reviewController.text,
                                date: createdAtController.text,
                              );
                              context.read<InspectionBloc>().add(InspectionEvent.addInspection(dataModel));

                              context.read<InspectionInvoiceBloc>().add(
                                InspectionInvoiceEvent.addToListInvoice(dataModel, 'unpaid'),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Submit',
                                style: whiteTextStyle,
                              ),
                            ),
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      );
                    },
                    listener: (context, state) {
                      state.maybeWhen(
                        orElse: () {},
                        loaded: (data) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: greenColor,
                              content: Text('Add Inspection Success'),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
