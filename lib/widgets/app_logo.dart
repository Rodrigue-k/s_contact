import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:s_contact/core/theme.dart';

class AppLogo extends StatelessWidget {
  final double sFontSize;
  final double contactFontSize;
  final bool centerTitle;

  const AppLogo({
    super.key,
    this.sFontSize = 24,
    this.contactFontSize = 24,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'S',
            style: GoogleFonts.inter(
              fontSize: sFontSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          TextSpan(
            text: ' Contact',
            style: GoogleFonts.inter(
              fontSize: contactFontSize,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
