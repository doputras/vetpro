import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetpro/bloc/list_inspection/list_inspection_bloc.dart';
import 'package:vetpro/common/components/species.dart';
import 'package:vetpro/common/components/states.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/components/tab_menu_widget.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/models/inspection_model.dart';
import 'package:vetpro/views/home/home_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _species; // null = all

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() => context
      .read<ListInspectionBloc>()
      .add(const ListInspectionEvent.getInspection());

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(InspectionModel i) {
    if (_species != null && speciesFor(i.animal).name != _species) return false;
    final q = _query.toLowerCase();
    return q.isEmpty ||
        i.animal.toLowerCase().contains(q) ||
        i.location.toLowerCase().contains(q) ||
        i.inspector.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TabMenuWidget(index: 1),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text('Riwayat', style: displayStyle(34)),
              const SizedBox(height: 4),
              Text('Semua catatan pemeriksaan, terbaru di atas.',
                  style: mutedStyle.copyWith(fontSize: 14)),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                textInputAction: TextInputAction.search,
                style: bodyStyle.copyWith(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Cari hewan, lokasi, atau pemeriksa',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => setState(() {
                            _searchController.clear();
                            _query = '';
                          }),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _filterChip(null, 'Semua'),
                    for (final s in speciesList) _filterChip(s.name, s.name),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              BlocBuilder<ListInspectionBloc, ListInspectionState>(
                builder: (context, state) => state.maybeWhen(
                  loaded: (data) => _list(data),
                  error: (m) => ErrorState(message: m, onRetry: _refresh),
                  orElse: () => const LoadingList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String? species, String label) {
    final selected = _species == species;
    final color = species == null ? yellowColor : speciesFor(species).color;
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 4),
      child: Semantics(
        button: true,
        selected: selected,
        child: InkWell(
          borderRadius: BorderRadius.circular(99),
          onTap: () => setState(() => _species = species),
          child: Container(
            padding: EdgeInsets.fromLTRB(species == null ? 16 : 6, 4, 14, 4),
            decoration: BoxDecoration(
              color: selected ? color : whiteColor,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: inkColor, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (species != null) ...[
                  SpeciesSticker(animal: species, size: 30),
                  const SizedBox(width: 6),
                ],
                Text(label,
                    style: labelStyle.copyWith(
                        fontSize: 13, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _list(List<InspectionModel> data) {
    if (data.isEmpty) {
      return const EmptyState(
        title: 'Riwayat masih kosong',
        message: 'Setiap pemeriksaan yang kamu simpan akan tercatat di sini.',
      );
    }
    // Already sorted newest-first by the datasource.
    final filtered = data.where(_matches).toList();
    if (filtered.isEmpty) {
      return EmptyState(
        title: 'Tidak ada yang cocok',
        message: 'Coba kata kunci lain atau pilih "Semua" hewan.',
        action: StickerButton(
          label: 'Reset filter',
          color: whiteColor,
          textColor: inkColor,
          expand: false,
          compact: true,
          onPressed: () => setState(() {
            _searchController.clear();
            _query = '';
            _species = null;
          }),
        ),
      );
    }

    // Group under one date heading instead of repeating the date per card.
    final groups = <String, List<InspectionModel>>{};
    for (final i in filtered) {
      groups.putIfAbsent(i.date, () => []).add(i);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 10),
            child: Row(
              children: [
                Text(
                  DateTime.tryParse(entry.key)?.formatDate() ?? entry.key,
                  style: labelStyle.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 10),
                const Expanded(child: Divider()),
                const SizedBox(width: 10),
                Text('${entry.value.length} cek', style: mutedStyle),
              ],
            ),
          ),
          for (final i in entry.value) InspectionCard(i, showDate: false),
        ],
      ],
    );
  }
}
