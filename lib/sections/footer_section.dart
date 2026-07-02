import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FooterBar extends StatelessWidget {
  final bool isMobile;
  const FooterBar({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 12,
        children: [
          Text(
            "© ${DateTime.now().year} Aya's Graphique. All rights reserved.",
            style: AppFonts.body(size: 12.5, color: AppColors.creamDim),
          ),
          Text(
            'Simplicity makes it Art',
            style: AppFonts.label(size: 11.5, letterSpacing: 1.6),
          ),
        ],
      ),
    );
  }
}
