import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:s_contact/core/theme.dart';
import 'package:s_contact/core/utils/vcard_helper.dart';
import 'package:s_contact/models/contact_model.dart';
import 'package:s_contact/providers/user_profile_provider.dart';
import 'package:s_contact/widgets/app_logo.dart';
import 'package:s_contact/widgets/contact_form.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const AppLogo(), centerTitle: false, elevation: 0),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorView(context),
        data: (profile) => profile == null
            ? _buildNoProfileView(context, ref, isDark)
            : _buildProfileView(context, profile, isDark),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: AppTheme.errorColor, size: 48),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: TextStyle(color: AppTheme.errorColor),
          ),
        ],
      ),
    );
  }

  Widget _buildNoProfileView(BuildContext context, WidgetRef ref, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configurez votre carte de visite numérique',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ContactForm(
            onSave: (contact) async {
              return await ref
                  .read(userProfileProvider.notifier)
                  .saveProfile(contact);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView(
    BuildContext context,
    ContactModel profile,
    bool isDark,
  ) {
    final qrData = VCardHelper.generateQRData(profile);
    // Use a high-quality nice gradient for the card background
    final gradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
          : [
              const Color(0xFF2563EB),
              const Color(0xFF1D4ED8),
            ], // Professional Blue
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Digital Business Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : const Color(0xFF2563EB))
                      .withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background decorative circles
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar / Initials
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            profile.getInitials(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Name & Title
                      Text(
                        profile.getDisplayName(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),

                      if (profile.jobTitle != null ||
                          profile.company != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          [profile.jobTitle, profile.company]
                              .where((e) => e != null && e.isNotEmpty)
                              .join('  •  '),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                      const HorizontalDivider(color: Colors.white24),
                      const SizedBox(height: 32),

                      // QR Code
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 180,
                          gapless: false,
                          // Make QR dark blue/black for better contrast
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Color(0xFF1E293B),
                          ),
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Scanner pour ajouter',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Bottom scroll padding
        ],
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  final Color color;
  const HorizontalDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity, height: 1, color: color);
  }
}
