// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/data/models/inspection_model.dart';

import '../../common/components/form.dart';
import '../../common/constants/theme.dart';

class DetailAnimalInpectionPage extends StatelessWidget {
  final InspectionModel inspectionModel;
  const DetailAnimalInpectionPage({
    Key? key,
    required this.inspectionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Domba Inpection',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              top: 20,
            ),
            child: Text(
              inspectionModel.createdAt!,
              style: blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
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
                    title: 'Hasil pemeriksaan hewan',
                    initialValue: inspectionModel.result,
                    fillColor: Colors.white,
                    maxLine: 6,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  CustomFormField(
                    title: 'Hewan',
                    initialValue: inspectionModel.animal,
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  CustomFormField(
                    title: 'Perawatan medis',
                    initialValue: inspectionModel.medicalTreatment,
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  CustomFormField(
                    title: 'Perawatan kandang',
                    initialValue: inspectionModel.cageTreatment,
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  CustomFormField(
                    title: 'Pemberian makan',
                    initialValue: inspectionModel.feeding!,
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  CustomFormField(
                    title: 'Perawatan lingkungan',
                    initialValue: inspectionModel.environmentalCare,
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  CustomFormField(
                    title: 'Saran tambahan',
                    initialValue: inspectionModel.suggestion,
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  CustomFormField(
                    title: 'Lokasi',
                    initialValue: inspectionModel.location,
                    fillColor: Colors.white,
                    maxLine: 2,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  CustomFormField(
                    title: inspectionModel.inspector!,
                    initialValue: 'Dr. joe',
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
                  Container(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
