import 'package:flutter/material.dart';
import 'package:vetpro/common/components/species.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';

/// Empty lists teach the next step instead of saying "nothing here".
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      child: Column(
        children: [
          const SizedBox(
            width: 150,
            height: 84,
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    top: 18,
                    child: SpeciesSticker(animal: 'Kelinci', tilt: -0.25)),
                Positioned(
                    left: 46,
                    top: 0,
                    child:
                        SpeciesSticker(animal: 'Domba', size: 60, tilt: 0.06)),
                Positioned(
                    right: 0,
                    top: 22,
                    child: SpeciesSticker(animal: 'Angsa', tilt: 0.3)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(title, style: displayStyle(20), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(message,
                style: mutedStyle.copyWith(fontSize: 14),
                textAlign: TextAlign.center),
          ),
          if (action != null) ...[const SizedBox(height: 18), action!],
        ],
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Sticker(
      color: errorSoftColor,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wifi_off_rounded, color: inkColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Waduh, datanya belum bisa dimuat',
                    style: labelStyle.copyWith(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Cek koneksi internet lalu coba lagi.', style: bodyStyle),
          const SizedBox(height: 4),
          Text(message,
              style: mutedStyle.copyWith(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 14),
          StickerButton(
            label: 'Coba lagi',
            icon: Icons.refresh_rounded,
            color: whiteColor,
            textColor: inkColor,
            expand: false,
            compact: true,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

/// Skeleton cards shaped like the real list, gently pulsing.
class LoadingList extends StatefulWidget {
  final int count;
  const LoadingList({super.key, this.count = 3});

  @override
  State<LoadingList> createState() => _LoadingListState();
}

class _LoadingListState extends State<LoadingList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.45,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final list = Column(
      children: List.generate(
        widget.count,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              color: tealSoftColor,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
    return Semantics(
      label: 'Memuat',
      child: noMotion ? list : FadeTransition(opacity: _c, child: list),
    );
  }
}
