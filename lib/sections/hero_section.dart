import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/shimmer_text.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;
  final bool isMobile;

  const HeroSection({
    super.key,
    required this.onViewWork,
    required this.onContact,
    required this.isMobile,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _ringController;
  Offset _mouse = Offset.zero; // -1..1

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent e, Size size) {
    setState(() {
      _mouse = Offset(
        ((e.position.dx / size.width) * 2 - 1).clamp(-1, 1),
        ((e.position.dy / size.height) * 2 - 1).clamp(-1, 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;

    final portrait = AnimatedBuilder(
      animation: Listenable.merge([_floatController, _ringController]),
      builder: (context, _) {
        final floatY = math.sin(_floatController.value * math.pi) * 10;
        final rotY = _mouse.dx * 0.18;
        final rotX = -_mouse.dy * 0.14;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0014)
            ..translate(0.0, floatY)
            ..rotateX(rotX)
            ..rotateY(rotY),
          child: SizedBox(
            width: isMobile ? 260 : 380,
            height: isMobile ? 260 : 380,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Rotating dashed ring — pure decoration, signals "crafted".
                Transform.rotate(
                  angle: _ringController.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size(isMobile ? 300 : 430, isMobile ? 300 : 430),
                    painter: _DashedRingPainter(color: AppColors.orchid),
                  ),
                ),
                Transform.rotate(
                  angle: -_ringController.value * 2 * math.pi * 0.6,
                  child: CustomPaint(
                    size: Size(isMobile ? 330 : 470, isMobile ? 330 : 470),
                    painter: _DashedRingPainter(
                      color: AppColors.violetPop,
                      dashCount: 60,
                    ),
                  ),
                ),
                // Glow behind portrait.
                Container(
                  width: isMobile ? 230 : 340,
                  height: isMobile ? 230 : 340,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.violetPop.withOpacity(0.45),
                        AppColors.violetPop.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: isMobile ? 220 : 320,
                  height: isMobile ? 220 : 320,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.violetGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 40,
                        offset: const Offset(0, 24),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/aya_portrait.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Two small orbiting accent dots — like little planets — for
                // an extra layer of continuous, independent motion.
                Transform.rotate(
                  angle: _ringController.value * 2 * math.pi,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.orchidSoft,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.orchid.withOpacity(0.7),
                            blurRadius: 14,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: -_ringController.value * 2 * math.pi * 0.6 + math.pi,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 14),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.violetPop,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.violetPop.withOpacity(0.7),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    final headline = Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 28, height: 2, color: AppColors.orchid),
            const SizedBox(width: 10),
            Text('ILLUSTRATOR · LOGO DESIGNER', style: AppFonts.label()),
          ],
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 22),
        ShimmerHeadline(
          text: "Aya's\nGraphique",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: AppFonts.display(
            size: isMobile ? 48 : 84,
            height: 1.02,
            color: Colors.white,
          ),
        )
            .animate()
            .fadeIn(duration: 700.ms, delay: 150.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 22),
        SizedBox(
          width: isMobile ? double.infinity : 460,
          child: Text(
            'Simplicity makes it Art — clean, characterful illustration '
            'and logo design for brands that want to feel hand-made, '
            'not template-made.',
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: AppFonts.body(size: 17),
          ),
        ).animate().fadeIn(duration: 700.ms, delay: 300.ms),
        const SizedBox(height: 34),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            _PrimaryButton(label: 'View the work', onTap: widget.onViewWork),
            _GhostButton(label: "Let's talk", onTap: widget.onContact),
          ],
        ).animate().fadeIn(duration: 700.ms, delay: 420.ms),
      ],
    );

    return MouseRegion(
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) _onHover(e, box.size);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: isMobile ? 60 : 40,
        ),
        child: isMobile
            ? Column(
                children: [
                  portrait,
                  const SizedBox(height: 48),
                  headline,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 6, child: headline),
                  const SizedBox(width: 40),
                  Expanded(flex: 5, child: Center(child: portrait)),
                ],
              ),
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  final Color color;
  final int dashCount;

  _DashedRingPainter({required this.color, this.dashCount = 90});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.55)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    const gapFraction = 0.45;
    for (int i = 0; i < dashCount; i++) {
      final a0 = (i / dashCount) * 2 * math.pi;
      final a1 = a0 + (2 * math.pi / dashCount) * gapFraction;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        a0,
        a1 - a0,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter oldDelegate) => false;
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          transform: Matrix4.identity()..scale(_hover ? 1.04 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: AppColors.violetGradient,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppColors.violetPop.withOpacity(_hover ? 0.45 : 0.25),
                blurRadius: _hover ? 28 : 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: AppFonts.label(
              size: 14,
              color: AppColors.bgDeep,
              letterSpacing: 1,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .custom(
              duration: 1800.ms,
              curve: Curves.easeInOut,
              builder: (context, value, child) => DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.violetPop.withOpacity(0.12 * value),
                      blurRadius: 10 * value,
                      spreadRadius: 2 * value,
                    ),
                  ],
                ),
                child: child,
              ),
            ),
      ),
    );
  }
}

class _GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GhostButton({required this.label, required this.onTap});

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hover ? AppColors.orchid : Colors.white.withOpacity(0.25),
              width: 1.4,
            ),
            color: _hover ? Colors.white.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            widget.label,
            style: AppFonts.label(
              size: 14,
              color: AppColors.cream,
              letterSpacing: 1,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
