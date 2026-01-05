import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s_contact/core/theme.dart';
import 'package:s_contact/core/utils/vcard_helper.dart';
import 'package:s_contact/models/contact_model.dart';
import 'package:s_contact/pages/save_contact_page.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    final String? value = barcode?.rawValue;

    if (value == null) return;

    // Smart Validation Logic
    final bool isContact =
        VCardHelper.isVCard(value) ||
        (value.startsWith('MECARD:')) ||
        (value.contains('TEL:') && value.contains('N:'));

    if (isContact) {
      _processScannedData(value);
    }
  }

  Future<void> _processScannedData(String data) async {
    setState(() => _isProcessing = true);

    HapticFeedback.heavyImpact();

    final ContactModel? contact = VCardHelper.parseVCard(data);

    if (contact != null && mounted) {
      // Pause simple feedback loop to avoid multiple triggers
      // Note: AiBarcodeScanner determines its own lifecycle, we just navigate away.

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SaveContactPage(contact: contact, rawData: data),
        ),
      );

      if (mounted) {
        setState(() => _isProcessing = false);
      }
    } else {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showErrorSnackBar('Format de contact non reconnu');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AiBarcodeScanner in v7+ is often simpler.
    // We wrap it to add our own overlay since custom props were missing.
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AiBarcodeScanner(
            onDetect: _onDetect,
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              formats: [BarcodeFormat.qrCode],
              returnImage: false,
            ),
            // Default UI of AiBarcodeScanner will serve as base.
            // We add our custom elements on top.
          ),

          // Custom Overlay / Frame
          // Since we couldn't configure internal overlay, we draw one on top
          // to ensure the "Professional" look and text.
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Placez le QR code ici",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          // Processing Overlay
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
