import 'package:flutter/material.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_section.dart';
import '../sections/footer_section.dart';
import '../sections/hero_section.dart';
import '../sections/portfolio_section.dart';
import '../sections/services_section.dart';
import '../sections/work_together_section.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_backdrop.dart';
import '../widgets/glass_nav_bar.dart';
import '../widgets/marquee_strip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());
  final List<String> _sectionNames = const [
    'About',
    'Experience',
    'Work',
    'Services',
    'Together',
    'Contact',
  ];
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveSection);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveSection);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateActiveSection() {
    final offset = _scrollController.offset + 200;
    int newIndex = 0;
    for (int i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero).dy + _scrollController.offset;
      if (offset >= position) newIndex = i;
    }
    if (newIndex != _activeIndex) {
      setState(() => _activeIndex = newIndex);
    }
  }

  void _scrollTo(int index) {
    final ctx = _sectionKeys[index].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);
    final isTablet = AppBreakpoints.isTablet(width);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: AnimatedBackdrop(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(height: isMobile ? 110 : 130),
                  HeroSection(
                    isMobile: isMobile,
                    onViewWork: () => _scrollTo(2),
                    onContact: () => _scrollTo(5),
                  ),
                  const MarqueeStrip(words: [
                    'ILLUSTRATION',
                    'LOGO DESIGN',
                    'BRAND IDENTITY',
                    'PACKAGING ART',
                    'EDITORIAL',
                  ]),
                  KeyedSubtree(
                    key: _sectionKeys[0],
                    child: AboutSection(isMobile: isMobile),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[1],
                    child: ExperienceSection(isMobile: isMobile),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[2],
                    child: PortfolioSection(isMobile: isMobile, isTablet: isTablet),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[3],
                    child: ServicesSection(isMobile: isMobile, isTablet: isTablet),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[4],
                    child: WorkTogetherSection(
                      isMobile: isMobile,
                      isTablet: isTablet,
                      onContact: () => _scrollTo(5),
                    ),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[5],
                    child: ContactSection(isMobile: isMobile),
                  ),
                  FooterBar(isMobile: isMobile),
                ],
              ),
            ),
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Center(
                child: GlassNavBar(
                  sections: _sectionNames,
                  activeIndex: _activeIndex,
                  isMobile: isMobile,
                  onSectionTap: _scrollTo,
                  onMenuTap: () => _showMobileMenu(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_sectionNames.length, (i) {
                return ListTile(
                  title: Text(
                    _sectionNames[i],
                    textAlign: TextAlign.center,
                    style: AppFonts.display(size: 20, weight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _scrollTo(i);
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
