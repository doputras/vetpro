import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';

/// One list row for inspections, schedules and invoices.
class RecordCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? meta;
  final Widget? trailing;
  final VoidCallback? onTap;

  const RecordCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.meta,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Sticker(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: labelStyle.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: mutedStyle),
                  ],
                  if (meta != null) ...[const SizedBox(height: 6), meta!],
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing ??
                (onTap == null
                    ? const SizedBox.shrink()
                    : const Icon(Icons.chevron_right_rounded,
                        color: inkColor, size: 26)),
          ],
        ),
      ),
    );
  }
}

/// Tear-off calendar stamp; yellow when the date is today.
class DateBadge extends StatelessWidget {
  final DateTime date;
  final double size;
  const DateBadge({super.key, required this.date, this.size = 56});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateUtils.isSameDay(now, date);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: today ? yellowColor : tealSoftColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: inkColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${date.day}', style: displayStyle(size * 0.4)),
          Text(DateFormat('MMM', 'id_ID').format(date).toUpperCase(),
              style: labelStyle.copyWith(
                  fontSize: size * 0.19, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
