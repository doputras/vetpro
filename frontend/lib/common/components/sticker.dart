import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';

/// The one surface in the app: thick ink outline + hard drop shadow.
/// With [onTap] it becomes pressable: it sinks into its shadow on press.
class Sticker extends StatefulWidget {
  final Widget child;
  final Color color;
  final double radius;
  final double depth;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool sunken;
  final String? semanticLabel;

  const Sticker({
    super.key,
    required this.child,
    this.color = whiteColor,
    this.radius = 18,
    this.depth = 4,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.sunken = false,
    this.semanticLabel,
  });

  @override
  State<Sticker> createState() => _StickerState();
}

class _StickerState extends State<Sticker> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final noMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final shadow = (_down || widget.sunken) ? 0.0 : widget.depth;

    final box = AnimatedContainer(
      duration: noMotion ? Duration.zero : const Duration(milliseconds: 90),
      curve: Curves.easeOutQuart,
      transform: Matrix4.translationValues(0, widget.depth - shadow, 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: inkColor, width: 2),
        boxShadow: [BoxShadow(color: inkColor, offset: Offset(0, shadow))],
      ),
      child: widget.child,
    );

    // Reserve the shadow's space so pressing never shifts the layout.
    final padded = Padding(
      padding: EdgeInsets.only(bottom: widget.depth),
      child: box,
    );
    if (widget.onTap == null) return padded;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _set(true),
          onTapUp: (_) => _set(false),
          onTapCancel: () => _set(false),
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap!();
          },
          child: padded,
        ),
      ),
    );
  }
}

class StickerButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final bool loading;
  final bool expand;
  final bool compact;

  const StickerButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color = primaryColor,
    this.textColor = whiteColor,
    this.loading = false,
    this.expand = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final fg = onPressed == null && !loading ? mutedColor : textColor;
    return Sticker(
      onTap: enabled ? onPressed : null,
      sunken: !enabled,
      color: onPressed == null && !loading ? disabledColor : color,
      radius: compact ? 14 : 16,
      depth: compact ? 3 : 4,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : 20,
        vertical: compact ? 9 : 15,
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading)
            SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
            )
          else if (icon != null)
            Icon(icon, color: fg, size: compact ? 18 : 20),
          if (loading || icon != null) SizedBox(width: compact ? 6 : 10),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: labelStyle.copyWith(
                color: fg,
                fontSize: compact ? 14 : 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StickerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color color;

  const StickerIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.color = whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Sticker(
        onTap: onPressed,
        semanticLabel: tooltip,
        color: color,
        radius: 14,
        depth: 3,
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 22, color: inkColor),
      ),
    );
  }
}

/// Small rounded label. Status is always text + color, never color alone.
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: inkColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: inkColor),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: labelStyle.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

/// App mark: a tilted red sticker with a paw and a yellow first-aid badge.
class VetproMark extends StatelessWidget {
  final double size;
  const VetproMark({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.08,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(size * 0.3),
                border: Border.all(color: inkColor, width: size > 60 ? 3 : 2),
                boxShadow: [
                  BoxShadow(color: inkColor, offset: Offset(0, size * 0.07)),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(Icons.pets, color: whiteColor, size: size * 0.54),
            ),
            Positioned(
              top: -size * 0.12,
              right: -size * 0.12,
              child: Container(
                width: size * 0.4,
                height: size * 0.4,
                decoration: BoxDecoration(
                  color: yellowColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: inkColor, width: 2),
                ),
                child: Icon(Icons.add, size: size * 0.3, color: inkColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(title, style: displayStyle(19))),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Screen app bar with a sticker back button.
PreferredSizeWidget stickerAppBar(
  BuildContext context,
  String title, {
  List<Widget> actions = const [],
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: 68,
    titleSpacing: 0,
    leadingWidth: 72,
    leading: Navigator.of(context).canPop()
        ? Center(
            child: StickerIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Kembali',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          )
        : null,
    title: Text(title),
    actions: [...actions, const SizedBox(width: 16)],
  );
}

/// Receipt-style perforation line.
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 2),
      painter: _DashPainter(),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = inkColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (double x = 1; x < size.width; x += 10) {
      canvas.drawLine(Offset(x, 1), Offset(x + 4, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
