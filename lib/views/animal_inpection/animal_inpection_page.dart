import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vetpro/bloc/inspection/inspection_bloc.dart';
import 'package:vetpro/bloc/inspection_invoice/inspection_invoice_bloc.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/models/inspection_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final TextEditingController animalController = TextEditingController();
  final TextEditingController createdAtController = TextEditingController();

  getCamera() async {
    try {
      pickedFile = (await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 800.0,
          maxWidth: 460.0,
          imageQuality: 100))!;
      setState(() {
        tempFile = File(pickedFile!.path);
        bytes = tempFile!.readAsBytesSync();
      });
    } catch (e) {
      print(e);
    }
  }

  String? selectedItem;
  String? otherItem;

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
    animalController.dispose();
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
          'Animal Inpection',
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
              controller: reviewController,
              title: 'Hasil pemeriksaan hewan',
              fillColor: Colors.white,
              maxLine: 6,
            ),
            const SizedBox(
              height: 11,
            ),
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
              controller: createdAtController,
              title: 'Tanggal pemeriksaan',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              controller: medicalController,
              title: 'Perawatan medis',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              controller: cageController,
              title: 'Perawatan kandang',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              controller: eatController,
              title: 'Pemberian makan',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              controller: scopeController,
              title: 'Perawatan lingkungan',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            CustomFormField(
              controller: suggestionController,
              title: 'Saran tambahan',
              fillColor: Colors.white,
              maxLine: 2,
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
              title: 'Nama Pemeriksaan',
              fillColor: Colors.white,
              maxLine: 2,
            ),
            const SizedBox(
              height: 11,
            ),
            const Text(
              'Bukti Gambar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(
              height: 8,
            ),
            (tempFile != null)
                ? Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                        color: greyColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: FileImage(
                            File(pickedFile!.path),
                          ),
                          fit: BoxFit.cover,
                        )),
                  )
                : Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: greyColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        color: whiteColor,
                        size: 32,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => getCamera(),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image,
                            size: 35,
                          ),
                          Text(
                            'Tambah Foto',
                            style: blackTextStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  BlocConsumer<InspectionBloc, InspectionState>(
                      builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        return InkWell(
                          onTap: () {
                            final dataModel = InspectionModel(
                              animal: selectedItem ??
                                  otherItem ??
                                  animalController.text,
                              cageTreatment: cageController.text,
                              environmentalCare: scopeController.text,
                              feeding: eatController.text,
                              inspector: inspectorController.text,
                              location: locationController.text,
                              medicalTreatment: medicalController.text,
                              suggestion: suggestionController.text,
                              result: reviewController.text,
                              createdAt: createdAtController.text,
                            );
                            context
                                .read<InspectionBloc>()
                                .add(InspectionEvent.addInspection(dataModel));

                            context.read<InspectionInvoiceBloc>().add(
                                InspectionInvoiceEvent.addToListInvoice(
                                    dataModel, 'unpaid'));
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check,
                                  size: 35,
                                  color: Colors.green,
                                ),
                                Text(
                                  'Selesai',
                                  style: blackTextStyle,
                                )
                              ],
                            ),
                          ),
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
                  }, listener: (context, state) {
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
                        });
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
