import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/views/history/history_page.dart';
import 'package:vetpro/views/home/home_page.dart';
import 'package:vetpro/views/invoice/invoice_page.dart';
import 'package:vetpro/views/schedule/schedule_page.dart';

class _Tab {
  final String label;
  final IconData icon;
  final Widget Function() page;
  const _Tab(this.label, this.icon, this.page);
}

final _tabs = [
  _Tab('Beranda', Icons.home_rounded, () => const HomePage()),
  _Tab('Riwayat', Icons.history_rounded, () => const HistoryPage()),
  _Tab('Jadwal', Icons.calendar_month_rounded, () => const SchedulePage()),
  _Tab('Tagihan', Icons.receipt_long_rounded, () => const InvoicePage()),
];

/// Sticker pill nav. Tabs replace the stack instead of piling pages on it.
class TabMenuWidget extends StatelessWidget {
  final int index;
  const TabMenuWidget({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final noMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: inkColor, width: 2),
            boxShadow: const [BoxShadow(color: inkColor, offset: Offset(0, 4))],
          ),
          child: Row(
            children: [
              for (var i = 0; i < _tabs.length; i++)
                Expanded(
                  child: Semantics(
                    selected: i == index,
                    button: true,
                    label: _tabs[i].label,
                    excludeSemantics: true,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: i == index
                          ? null
                          : () => Get.offAll(
                                _tabs[i].page,
                                transition: Transition.fadeIn,
                                duration: noMotion
                                    ? Duration.zero
                                    : const Duration(milliseconds: 180),
                              ),
                      child: AnimatedContainer(
                        duration: noMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 200),
                        curve: Curves.easeOutQuart,
                        height: 56,
                        decoration: BoxDecoration(
                          color: i == index ? tealColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_tabs[i].icon,
                                size: 24,
                                color: i == index ? whiteColor : inkColor),
                            const SizedBox(height: 2),
                            Text(
                              _tabs[i].label,
                              style: labelStyle.copyWith(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: i == index ? whiteColor : inkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
