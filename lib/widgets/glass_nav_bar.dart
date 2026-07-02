import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassNavBar extends StatefulWidget {
  final List<String> sections;
  final int activeIndex;
  final ValueChanged<int> onSectionTap;
  final bool isMobile;
  final VoidCallback? onMenuTap;

  const GlassNavBar({
    super.key,
    required this.sections,
    required this.activeIndex,
    required this.onSectionTap,
    this.isMobile = false,
    this.onMenuTap,
  });

  @override
  State<GlassNavBar> createState() => _GlassNavBarState();
}

class _GlassNavBarState extends State<GlassNavBar> {
  int? _hovered;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.55),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (rect) =>
                    AppColors.violetGradient.createShader(rect),
                child: Text(
                  'AG',
                  style: AppFonts.display(
                      size: 20, weight: FontWeight.w800, color: Colors.white),
                ),
              ),
              const SizedBox(width: 18),
              if (!widget.isMobile)
                ...List.generate(widget.sections.length, (i) {
                  final active = i == widget.activeIndex;
                  final hovered = i == _hovered;
                  return MouseRegion(
                    onEnter: (_) => setState(() => _hovered = i),
                    onExit: (_) => setState(() => _hovered = null),
                    child: GestureDetector(
                      onTap: () => widget.onSectionTap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: active
                                  ? AppColors.orchid
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          widget.sections[i],
                          style: AppFonts.label(
                            size: 13,
                            color: active || hovered
                                ? AppColors.cream
                                : AppColors.creamDim,
                            letterSpacing: 1.4,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                })
              else
                IconButton(
                  onPressed: widget.onMenuTap,
                  icon: const Icon(Icons.menu_rounded, color: AppColors.cream),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
