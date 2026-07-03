import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import 'widgets/projects_tab.dart';
import 'widgets/messages_tab.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _tab = 0;

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final email = Supabase.instance.client.auth.currentUser?.email ?? '';
    final isMobile = MediaQuery.of(context).size.width < 720;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: 18,
              ),
              child: Row(
                children: [
                  Text('ADMIN', style: AppFonts.label(color: AppColors.violetLight)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Aya's Graphique dashboard",
                      style: AppFonts.display(size: isMobile ? 18 : 22, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!isMobile) ...[
                    Text(email, style: AppFonts.body(size: 13, color: AppColors.creamDim)),
                    const SizedBox(width: 16),
                  ],
                  TextButton.icon(
                    onPressed: _signOut,
                    icon: const Icon(Icons.logout_rounded, size: 16, color: AppColors.creamDim),
                    label: Text('Sign out', style: AppFonts.label(size: 12, color: AppColors.creamDim)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
              child: Row(
                children: [
                  _TabButton(
                    label: 'Projects',
                    icon: Icons.grid_view_rounded,
                    selected: _tab == 0,
                    onTap: () => setState(() => _tab = 0),
                  ),
                  const SizedBox(width: 10),
                  _TabButton(
                    label: 'Messages',
                    icon: Icons.mail_outline_rounded,
                    selected: _tab == 1,
                    onTap: () => setState(() => _tab = 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: const [
                  ProjectsTab(),
                  MessagesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.surfaceRaised : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.violetPop.withOpacity(0.5) : Colors.white.withOpacity(0.08),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: selected ? AppColors.orchid : AppColors.creamDim),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppFonts.label(
                  size: 12.5,
                  color: selected ? Colors.white : AppColors.creamDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
