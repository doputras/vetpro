import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/bloc/schedule/schedule_bloc.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/components/species.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/models/schedule_response_model.dart';
import 'package:vetpro/views/schedule/schedule_form_page.dart';
import 'package:vetpro/views/schedule/schedule_page.dart';

class DetailSchedulePage extends StatelessWidget {
  final Schedule schedule;
  const DetailSchedulePage({super.key, required this.schedule});

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus jadwal ini?'),
        content: Text(
            'Jadwal ${schedule.animalName ?? ''} akan dihapus dan tidak bisa dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context
          .read<ScheduleBloc>()
          .add(ScheduleEvent.deleteSchedule(schedule.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = schedule.inspectionDate;
    return Scaffold(
      appBar: stickerAppBar(context, 'Detail jadwal'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          SpeciesHeader(
            animal: schedule.animalName,
            title: schedule.animalName ?? '-',
            subtitle: date?.formatLong() ?? '-',
            chips: [
              if ((schedule.location ?? '').trim().isNotEmpty)
                (Icons.place_rounded, schedule.location!),
              if ((schedule.inspector ?? '').trim().isNotEmpty)
                (Icons.person_rounded, schedule.inspector!),
            ],
          ),
          const SizedBox(height: 16),
          Sticker(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoRow('Catatan', schedule.description),
              ],
            ),
          ),
        ],
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
              state.maybeWhen(
                orElse: () {},
                loadedDelete: (_) {
                  Get.offAll(() => const SchedulePage());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Jadwal dihapus.')),
                  );
                },
                error: (message) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menghapus: $message')),
                ),
              );
            },
            builder: (context, state) {
              final loading =
                  state.maybeWhen(loading: () => true, orElse: () => false);
              return Row(
                children: [
                  StickerButton(
                    label: 'Hapus',
                    icon: Icons.delete_outline_rounded,
                    color: whiteColor,
                    textColor: primaryColor,
                    expand: false,
                    loading: loading,
                    onPressed: () => _confirmDelete(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StickerButton(
                      label: 'Ubah jadwal',
                      icon: Icons.edit_rounded,
                      color: tealColor,
                      onPressed: loading
                          ? null
                          : () => Get.to(
                              () => ScheduleFormPage(schedule: schedule)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
