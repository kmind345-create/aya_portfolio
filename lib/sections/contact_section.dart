import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';

class ContactSection extends StatelessWidget {
  final bool isMobile;
  const ContactSection({super.key, required this.isMobile});

  static const _whatsappNumber = '201010660135';

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/$_whatsappNumber?text=${Uri.encodeComponent('Hi Aya! I found your portfolio and I\'d love to talk about a project.')}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 70 : 130,
      ),
      child: RevealOnScroll(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('LET\'S MAKE SOMETHING', style: AppFonts.label()),
            const SizedBox(height: 18),
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                colors: [AppColors.cream, AppColors.orchidSoft, AppColors.violetPop],
              ).createShader(rect),
              child: Text(
                'Have a brand or story\nthat needs a face?',
                textAlign: TextAlign.center,
                style: AppFonts.display(
                  size: isMobile ? 32 : 52,
                  height: 1.12,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: 480,
              child: Text(
                "Tell me about your brand, your characters, or the mark "
                "you've been picturing — I read every message myself.",
                textAlign: TextAlign.center,
                style: AppFonts.body(size: 16),
              ),
            ),
            const SizedBox(height: 40),
            _WhatsAppButton(onTap: _openWhatsApp),
            const SizedBox(height: 56),
            Wrap(
              spacing: 28,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: const [
                _SocialLink(
                  label: 'Instagram',
                  url: 'https://www.instagram.com/ayas_graphique/',
                ),
                _SocialLink(
                  label: 'Behance',
                  url: 'https://www.behance.net/ayaattiaabed',
                ),
                _SocialLink(
                  label: 'Facebook',
                  url: 'https://www.facebook.com/aya.attia.abed97',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WhatsAppButton extends StatefulWidget {
  final VoidCallback onTap;
  const _WhatsAppButton({required this.onTap});

  @override
  State<_WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<_WhatsAppButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
          transform: Matrix4.identity()..scale(_hover ? 1.05 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: AppColors.violetGradient,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppColors.violetPop.withOpacity(_hover ? 0.5 : 0.28),
                blurRadius: _hover ? 34 : 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.chat_rounded, size: 18, color: AppColors.bgDeep),
              const SizedBox(width: 10),
              Text(
                'Chat on WhatsApp',
                style: AppFonts.label(
                  size: 14.5,
                  color: AppColors.bgDeep,
                  letterSpacing: 0.4,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_outward_rounded,
                  size: 18, color: AppColors.bgDeep),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLink extends StatefulWidget {
  final String label;
  final String url;
  const _SocialLink({required this.label, required this.url});

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hover = false;

  Future<void> _open() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: AppFonts.label(
            size: 13,
            color: _hover ? AppColors.orchid : AppColors.creamDim,
            letterSpacing: 1.2,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
