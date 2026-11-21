import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:vetpro/bloc/list_inspection/list_inspection_bloc.dart';
import 'package:vetpro/common/components/record_card.dart';
import 'package:vetpro/common/components/species.dart';
import 'package:vetpro/common/components/states.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/components/tab_menu_widget.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/inspection_model.dart';
import 'package:vetpro/views/animal_inpection/animal_inpection_page.dart';
import 'package:vetpro/views/animal_inpection/detail_animal_inpection_page.dart';
import 'package:vetpro/views/auth/login_page.dart';
import 'package:vetpro/views/history/history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = '';

  @override
  void initState() {
    super.initState();
    _refresh();
    AuthLocalDatasource().getName().then((n) {
      if (mounted) setState(() => _name = n ?? '');
    });
  }

  void _refresh() => context
      .read<ListInspectionBloc>()
      .add(const ListInspectionEvent.getInspection());

  Future<void> _startInspection([String? animal]) async {
    await Get.to(() => AnimalInpectionPage(initialAnimal: animal));
    if (mounted) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    // "drh. Sari Wulandari" -> "Sari": skip titles ending in a dot.
    final words = _name.trim().split(RegExp(r'\s+'));
    final firstName =
        words.firstWhere((w) => !w.endsWith('.'), orElse: () => words.first);
    return Scaffold(
      bottomNavigationBar: const TabMenuWidget(index: 0),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Row(
                children: [
                  const VetproMark(size: 44),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstName.isEmpty ? 'Halo!' : 'Halo, $firstName!',
                          style: displayStyle(26),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(DateTime.now().formatDay(), style: mutedStyle),
                      ],
                    ),
                  ),
                  StickerIconButton(
                    icon: Icons.logout_rounded,
                    tooltip: 'Keluar',
                    onPressed: () async {
                      await AuthLocalDatasource().logout();
                      Get.offAll(() => const LoginPage());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _StartCard(onTap: () => _startInspection()),
              const SizedBox(height: 26),
              const SectionHeader('Langsung pilih hewannya'),
              SizedBox(
                height: 112,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: speciesList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final s = speciesList[i];
                    return SizedBox(
                      width: 92,
                      child: Sticker(
                        onTap: () => _startInspection(s.name),
                        semanticLabel: 'Periksa ${s.name}',
                        depth: 3,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            SpeciesSticker(animal: s.name, size: 50),
                            const SizedBox(height: 6),
                            Text(s.name,
                                style: labelStyle.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),
              SectionHeader(
                'Pemeriksaan terakhir',
                trailing: TextButton(
                  onPressed: () => Get.offAll(() => const HistoryPage(),
                      transition: Transition.fadeIn),
                  child: const Text('Lihat semua'),
                ),
              ),
              BlocBuilder<ListInspectionBloc, ListInspectionState>(
                builder: (context, state) => state.maybeWhen(
                  loaded: (data) => data.isEmpty
                      ? EmptyState(
                          title: 'Belum ada pemeriksaan',
                          message:
                              'Catatan pertamamu akan muncul di sini. Mulai dari hewan yang paling dekat!',
                          action: StickerButton(
                            label: 'Mulai sekarang',
                            expand: false,
                            onPressed: () => _startInspection(),
                          ),
                        )
                      : Column(
                          children: [
                            for (final i in data.take(3)) InspectionCard(i),
                          ],
                        ),
                  error: (m) => ErrorState(message: m, onRetry: _refresh),
                  orElse: () => const LoadingList(count: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartCard extends StatelessWidget {
  final VoidCallback onTap;
  const _StartCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Sticker(
      onTap: onTap,
      semanticLabel: 'Mulai pemeriksaan',
      color: primaryColor,
      radius: 24,
      depth: 6,
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusPill(
                  label: 'Cek kesehatan',
                  color: yellowColor,
                  icon: Icons.medical_services_rounded,
                ),
                const SizedBox(height: 12),
                Text('Mulai\npemeriksaan',
                    style: displayStyle(30, color: whiteColor)),
                const SizedBox(height: 6),
                Text('Catat hasil cek hewan dalam semenit.',
                    style: bodyStyle.copyWith(
                        color: whiteColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: whiteColor,
              shape: BoxShape.circle,
              border: Border.all(color: inkColor, width: 2),
            ),
            child: const Icon(Icons.arrow_forward_rounded,
                color: inkColor, size: 28),
          ),
        ],
      ),
    );
  }
}

/// Inspection row shared by Home and History.
class InspectionCard extends StatelessWidget {
  final InspectionModel inspection;
  final bool showDate;
  const InspectionCard(this.inspection, {super.key, this.showDate = true});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(inspection.date);
    final who = [inspection.location, inspection.inspector]
        .where((s) => s.trim().isNotEmpty)
        .join(' · ');
    return RecordCard(
      leading: SpeciesSticker(animal: inspection.animal, size: 54),
      title: inspection.animal,
      subtitle: who,
      meta: date == null || !showDate
          ? null
          : Row(
              children: [
                const Icon(Icons.event_rounded, size: 15, color: mutedColor),
                const SizedBox(width: 4),
                Text(date.formatDate(),
                    style: mutedStyle.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
      onTap: () =>
          Get.to(() => DetailAnimalInpectionPage(inspectionModel: inspection)),
    );
  }
}
