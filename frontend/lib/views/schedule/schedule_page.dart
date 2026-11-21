import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vetpro/bloc/schedule/schedule_bloc.dart';
import 'package:vetpro/common/components/record_card.dart';
import 'package:vetpro/common/components/species.dart';
import 'package:vetpro/common/components/states.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/components/tab_menu_widget.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/datasources/schedule_remote_datasource.dart';
import 'package:vetpro/data/models/schedule_response_model.dart';
import 'package:vetpro/views/schedule/detail_schedule_page.dart';
import 'package:vetpro/views/schedule/schedule_form_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime? _selected; // null = show every upcoming schedule
  Set<DateTime> _busyDays = {};

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() =>
      context.read<ScheduleBloc>().add(const ScheduleEvent.getSchedule());

  /// Existing "Schedule Control" rule: schedules from before today are
  /// removed on the server. Runs once per load, not on every rebuild.
  Future<void> _autoDeleteSchedules(List<Schedule> schedules) async {
    final today = DateUtils.dateOnly(DateTime.now());
    for (final s in schedules) {
      final date = s.inspectionDate;
      if (date == null || !DateUtils.dateOnly(date).isBefore(today)) continue;
      final res = await ScheduleRemoteDatasource().deleteSchedule(s.id!);
      res.fold(
        (error) => debugPrint('Error deleting schedule ${s.id}: $error'),
        (_) => debugPrint('Schedule ${s.id} deleted (expired).'),
      );
    }
  }

  void _create() => Get.to(() => ScheduleFormPage(initialDate: _selected));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TabMenuWidget(index: 2),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Row(
                children: [
                  Expanded(child: Text('Jadwal', style: displayStyle(34))),
                  StickerButton(
                    label: 'Buat',
                    icon: Icons.add_rounded,
                    expand: false,
                    compact: true,
                    onPressed: _create,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Sticker(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: CalendarDatePicker2(
                  config: _calendarConfig(),
                  value: _selected == null ? [] : [_selected],
                  onValueChanged: (dates) => setState(() => _selected =
                      dates.isEmpty ? null : DateUtils.dateOnly(dates.first)),
                ),
              ),
              const SizedBox(height: 22),
              SectionHeader(
                _selected == null
                    ? 'Akan datang'
                    : 'Jadwal ${_selected!.formatDate()}',
                trailing: _selected == null
                    ? null
                    : TextButton(
                        onPressed: () => setState(() => _selected = null),
                        child: const Text('Lihat semua'),
                      ),
              ),
              BlocConsumer<ScheduleBloc, ScheduleState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    loadedGet: (model) {
                      _autoDeleteSchedules(model.data);
                      setState(() => _busyDays = {
                            for (final s in model.data)
                              if (s.inspectionDate != null)
                                DateUtils.dateOnly(s.inspectionDate!),
                          });
                    },
                  );
                },
                builder: (context, state) => state.maybeWhen(
                  loadedGet: (model) => _list(model.data),
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

  Widget _list(List<Schedule> all) {
    final today = DateUtils.dateOnly(DateTime.now());
    final items = all.where((s) {
      final d = s.inspectionDate;
      if (d == null) return false;
      if (_selected != null) return DateUtils.isSameDay(d, _selected);
      return !DateUtils.dateOnly(d).isBefore(today);
    }).toList()
      ..sort((a, b) => a.inspectionDate!.compareTo(b.inspectionDate!));

    if (items.isEmpty) {
      return EmptyState(
        title: _selected == null ? 'Belum ada jadwal' : 'Tanggal ini kosong',
        message: _selected == null
            ? 'Rencanakan pemeriksaan berikutnya supaya tidak ada yang terlewat.'
            : 'Tidak ada pemeriksaan di tanggal ini. Mau buat satu?',
        action: StickerButton(
          label: 'Buat jadwal',
          icon: Icons.add_rounded,
          expand: false,
          onPressed: _create,
        ),
      );
    }

    return Column(
      children: [
        for (final s in items)
          RecordCard(
            leading: DateBadge(date: s.inspectionDate!),
            title: s.animalName ?? '-',
            subtitle: [s.location, s.inspector]
                .where((v) => (v ?? '').trim().isNotEmpty)
                .join(' · '),
            meta: DateUtils.isSameDay(s.inspectionDate, today)
                ? const StatusPill(label: 'Hari ini', color: yellowColor)
                : null,
            trailing: SpeciesSticker(animal: s.animalName, size: 40),
            onTap: () => Get.to(() => DetailSchedulePage(schedule: s)),
          ),
      ],
    );
  }

  CalendarDatePicker2Config _calendarConfig() {
    return CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.single,
      firstDayOfWeek: 1,
      weekdayLabels: const ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'],
      weekdayLabelTextStyle: mutedStyle.copyWith(fontWeight: FontWeight.w800),
      controlsTextStyle: displayStyle(18),
      centerAlignModePicker: true,
      disableMonthPicker: true,
      modePickerTextHandler: ({required monthDate, isMonthPicker}) =>
          DateFormat('MMMM yyyy', 'id_ID').format(monthDate),
      selectedDayHighlightColor: primaryColor,
      dayBuilder: _day,
    );
  }

  Widget? _day({
    required DateTime date,
    TextStyle? textStyle,
    BoxDecoration? decoration,
    bool? isSelected,
    bool? isDisabled,
    bool? isToday,
  }) {
    final selected = isSelected == true;
    final today = isToday == true;
    final busy = _busyDays.contains(DateUtils.dateOnly(date));
    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: selected ? primaryColor : (today ? yellowColor : null),
          borderRadius: BorderRadius.circular(12),
          border:
              selected || today ? Border.all(color: inkColor, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: labelStyle.copyWith(
                fontWeight: FontWeight.w800,
                color: selected
                    ? whiteColor
                    : (isDisabled == true ? disabledColor : inkColor),
              ),
            ),
            if (busy)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: selected ? whiteColor : primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
