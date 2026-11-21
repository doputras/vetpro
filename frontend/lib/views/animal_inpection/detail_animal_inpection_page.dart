import 'package:flutter/material.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/components/species.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/models/inspection_model.dart';

class DetailAnimalInpectionPage extends StatelessWidget {
  final InspectionModel inspectionModel;
  const DetailAnimalInpectionPage({super.key, required this.inspectionModel});

  @override
  Widget build(BuildContext context) {
    final i = inspectionModel;
    final date = DateTime.tryParse(i.date);
    return Scaffold(
      appBar: stickerAppBar(context, 'Detail pemeriksaan'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          SpeciesHeader(
            animal: i.animal,
            title: i.animal,
            subtitle: date?.formatLong() ?? i.date,
            chips: [
              if (i.location.trim().isNotEmpty)
                (Icons.place_rounded, i.location),
              if (i.inspector.trim().isNotEmpty)
                (Icons.person_rounded, i.inspector),
            ],
          ),
          const SizedBox(height: 16),
          Sticker(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoRow('Hasil pemeriksaan', i.result),
                const Divider(),
                InfoRow('Perawatan medis', i.medicalTreatment),
                const Divider(),
                InfoRow('Perawatan kandang', i.cageTreatment),
                const Divider(),
                InfoRow('Pemberian makan', i.feeding),
                const Divider(),
                InfoRow('Perawatan lingkungan', i.environmentalCare),
                const Divider(),
                InfoRow('Saran tambahan', i.suggestion),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
