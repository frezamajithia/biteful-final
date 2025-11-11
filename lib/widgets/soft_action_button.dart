import 'package:flutter/material.dart';
import '../theme.dart';

class SoftActionButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool filledWhenIdle;
  final EdgeInsetsGeometry padding;

  const SoftActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filledWhenIdle = false,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  });

  @override
  State<SoftActionButton> createState() => _SoftActionButtonState();
}

class _SoftActionButtonState extends State<SoftActionButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.filledWhenIdle
                ? (enabled ? kPrimary : Colors.grey.shade300)
                : Colors.transparent,
            border: widget.filledWhenIdle
                ? null
                : Border.all(
                    color: enabled
                        ? kPrimary.withOpacity(0.5)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.filledWhenIdle && enabled
                ? [
                    BoxShadow(
                      color: kPrimary.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.filledWhenIdle
                    ? Colors.white
                    : (enabled ? kPrimary : Colors.grey.shade500),
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}