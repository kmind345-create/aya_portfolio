import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../theme/app_theme.dart';
import 'admin_dashboard_screen.dart';
import 'admin_login_screen.dart';

/// Entry point for the /admin route. Shows a "not configured" notice if
/// Supabase hasn't been set up yet, otherwise routes between the login
/// screen and the dashboard based on the current auth session.
class AdminGateScreen extends StatelessWidget {
  const AdminGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.isConfigured) {
      return const _NotConfiguredScreen();
    }

    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session == null) {
          return const AdminLoginScreen();
        }
        return const AdminDashboardScreen();
      },
    );
  }
}

class _NotConfiguredScreen extends StatelessWidget {
  const _NotConfiguredScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.storage_rounded, size: 48, color: AppColors.violetLight),
              const SizedBox(height: 20),
              Text(
                'Supabase isn\'t configured yet',
                style: AppFonts.display(size: 22, color: Colors.white),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 420,
                child: Text(
                  'Add your project URL and anon key to '
                  'lib/config/supabase_config.dart, then reload.',
                  textAlign: TextAlign.center,
                  style: AppFonts.body(size: 14, color: AppColors.creamDim),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
