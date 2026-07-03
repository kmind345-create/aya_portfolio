import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/messages_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';

class ContactSection extends StatefulWidget {
  final bool isMobile;
  const ContactSection({super.key, required this.isMobile});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  static const _whatsappNumber = '201010660135';
  bool get isMobile => widget.isMobile;

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
            const SizedBox(height: 40),
            Text('OR SEND A MESSAGE', style: AppFonts.label(size: 11, color: AppColors.creamDim)),
            const SizedBox(height: 22),
            const _MessageForm(),
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

class _MessageForm extends StatefulWidget {
  const _MessageForm();

  @override
  State<_MessageForm> createState() => _MessageFormState();
}

enum _SendStatus { idle, sending, sent, error }

class _MessageFormState extends State<_MessageForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  _SendStatus _status = _SendStatus.idle;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _status = _SendStatus.sending);
    try {
      await MessagesRepository.send(
        name: _name.text.trim(),
        email: _email.text.trim(),
        message: _message.text.trim(),
      );
      _name.clear();
      _email.clear();
      _message.clear();
      setState(() => _status = _SendStatus.sent);
    } catch (_) {
      setState(() => _status = _SendStatus.error);
    }
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: AppFonts.body(size: 13, color: AppColors.creamDim),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.violetPop),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 480,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              style: AppFonts.body(size: 14, color: Colors.white),
              decoration: _decoration('Your name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              style: AppFonts.body(size: 14, color: Colors.white),
              decoration: _decoration('Your email'),
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _message,
              maxLines: 4,
              style: AppFonts.body(size: 14, color: Colors.white),
              decoration: _decoration('Tell me about your project'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _status == _SendStatus.sending ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceRaised,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.white.withOpacity(0.12)),
                  ),
                ),
                child: _status == _SendStatus.sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text('Send message', style: AppFonts.label(size: 13, color: Colors.white)),
              ),
            ),
            if (_status == _SendStatus.sent) ...[
              const SizedBox(height: 12),
              Text('Thanks — I\'ll get back to you soon!',
                  style: AppFonts.body(size: 13, color: AppColors.orchid)),
            ],
            if (_status == _SendStatus.error) ...[
              const SizedBox(height: 12),
              Text('Something went wrong — try WhatsApp instead?',
                  style: AppFonts.body(size: 13, color: Colors.redAccent)),
            ],
          ],
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
