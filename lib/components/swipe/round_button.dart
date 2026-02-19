
import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
   RoundButton({
    required this.onTap,
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
    required this.glowColor,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final Color glowColor;

  @override
  State<RoundButton> createState() => RoundButtonState();
}

class RoundButtonState extends State<RoundButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration:  Duration(milliseconds: 90),
      reverseDuration:  Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.84)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _ctrl.forward() : null,
      onTapUp: widget.onTap != null
          ? (_) {
              _ctrl.reverse();
              widget.onTap!();
            }
          : null,
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: widget.glowColor,
                blurRadius: 20,
                spreadRadius: 2,
                offset:  Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset:  Offset(0, 2),
              ),
            ],
          ),
          child: Icon(widget.icon, color: widget.color, size: widget.iconSize),
        ),
      ),
    );
  }
}