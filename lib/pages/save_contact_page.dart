import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s_contact/core/theme.dart';
import 'package:s_contact/models/contact_model.dart';

/// Page pour prévisualiser et sauvegarder un contact scanné
class SaveContactPage extends StatefulWidget {
  final ContactModel contact;
  final String? rawData;

  const SaveContactPage({super.key, required this.contact, this.rawData});

  @override
  State<SaveContactPage> createState() => _SaveContactPageState();
}

class _SaveContactPageState extends State<SaveContactPage> {
  bool _isSaving = false;
  bool _hasContactsPermission = false;
  List<_AccountInfo> _availableAccounts = [];
  _AccountInfo? _selectedAccount;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndLoadAccounts();
  }

  Future<void> _checkPermissionsAndLoadAccounts() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      _hasContactsPermission = result.isGranted;
    } else {
      _hasContactsPermission = true;
    }

    if (_hasContactsPermission) {
      await _loadAccounts();
    }

    if (mounted) setState(() {});
  }

  Future<void> _loadAccounts() async {
    try {
      // Get contacts with accounts to detect available sync accounts
      final contacts = await FlutterContacts.getContacts(withAccounts: true);
      final Set<String> accountNames = {};

      for (final contact in contacts) {
        for (final account in contact.accounts) {
          accountNames.add('${account.name}|${account.type}');
        }
      }

      final accounts = <_AccountInfo>[];

      // Add detected accounts
      for (final accountStr in accountNames) {
        final parts = accountStr.split('|');
        if (parts.length == 2) {
          accounts.add(
            _AccountInfo(
              name: parts[0],
              type: parts[1],
              icon: _getAccountIcon(parts[0], parts[1]),
              color: _getAccountColor(parts[0], parts[1]),
            ),
          );
        }
      }

      // Always add local device option
      accounts.insert(
        0,
        _AccountInfo(
          name: 'Appareil local',
          type: Platform.isIOS ? 'iPhone' : 'Android',
          icon: Icons.phone_android_rounded,
          color: Colors.grey,
        ),
      );

      if (mounted) {
        setState(() {
          _availableAccounts = accounts;
          _selectedAccount = accounts.isNotEmpty ? accounts.first : null;
        });
      }
    } catch (e) {
      debugPrint('Could not load accounts: $e');
      // Fallback to local only
      setState(() {
        _availableAccounts = [
          _AccountInfo(
            name: 'Appareil local',
            type: Platform.isIOS ? 'iPhone' : 'Android',
            icon: Icons.phone_android_rounded,
            color: Colors.grey,
          ),
        ];
        _selectedAccount = _availableAccounts.first;
      });
    }
  }

  IconData _getAccountIcon(String name, String type) {
    final lowerName = name.toLowerCase();
    final lowerType = type.toLowerCase();

    if (lowerName.contains('gmail') ||
        lowerName.contains('google') ||
        lowerType.contains('google')) {
      return Icons.mail_rounded;
    } else if (lowerName.contains('icloud') || lowerType.contains('icloud')) {
      return Icons.cloud_rounded;
    } else if (lowerType.contains('exchange') ||
        lowerType.contains('outlook')) {
      return Icons.business_rounded;
    }
    return Icons.account_circle_rounded;
  }

  Color _getAccountColor(String name, String type) {
    final lowerName = name.toLowerCase();
    final lowerType = type.toLowerCase();

    if (lowerName.contains('gmail') ||
        lowerName.contains('google') ||
        lowerType.contains('google')) {
      return const Color(0xFFDB4437);
    } else if (lowerName.contains('icloud') || lowerType.contains('icloud')) {
      return const Color(0xFF007AFF);
    } else if (lowerType.contains('exchange') ||
        lowerType.contains('outlook')) {
      return const Color(0xFF0078D4);
    }
    return Colors.grey;
  }

  Future<void> _saveContact() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      if (!_hasContactsPermission) {
        _showSnackBar('Permission de contacts requise', isError: true);
        setState(() => _isSaving = false);
        return;
      }

      final newContact = Contact(
        name: Name(
          first: widget.contact.firstName ?? '',
          last: widget.contact.lastName ?? '',
        ),
        phones: [
          if (widget.contact.phone != null && widget.contact.phone!.isNotEmpty)
            Phone(widget.contact.phone!),
        ],
        emails: [
          if (widget.contact.email != null && widget.contact.email!.isNotEmpty)
            Email(widget.contact.email!),
        ],
        organizations: [
          if (widget.contact.company != null &&
              widget.contact.company!.isNotEmpty)
            Organization(
              company: widget.contact.company!,
              title: widget.contact.title ?? widget.contact.jobTitle ?? '',
            ),
        ],
        websites: [
          if (widget.contact.website != null &&
              widget.contact.website!.isNotEmpty)
            Website(widget.contact.website!),
        ],
        notes: [
          if (widget.contact.note != null && widget.contact.note!.isNotEmpty)
            Note(widget.contact.note!),
        ],
      );

      await FlutterContacts.insertContact(newContact);

      if (mounted) {
        _showSnackBar(
          'Contact enregistré${_selectedAccount != null ? ' dans ${_selectedAccount!.name}' : ''} !',
          isError: false,
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Erreur: $e', isError: true);
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_rounded : Icons.check_circle_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? AppTheme.errorColor : AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contact = widget.contact;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Contact'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _saveContact,
            icon: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryColor,
                    ),
                  )
                : const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Card Preview
            _buildContactCard(context, contact, isDark),

            const SizedBox(height: 24),

            // Account Selection
            if (_availableAccounts.isNotEmpty) ...[
              Text(
                'Enregistrer dans',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildAccountSelector(isDark),
              const SizedBox(height: 24),
            ],

            // Contact Details
            Text(
              'Détails du contact',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailsList(context, contact, isDark),

            const SizedBox(height: 32),

            // Save Button
            _buildSaveButton(isDark),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    ContactModel contact,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                contact.getInitials(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            contact.getDisplayName(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (contact.company != null || contact.jobTitle != null) ...[
            const SizedBox(height: 8),
            Text(
              [
                contact.jobTitle,
                contact.company,
              ].where((e) => e != null && e.isNotEmpty).join(' • '),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountSelector(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _availableAccounts.asMap().entries.map((entry) {
          final index = entry.key;
          final account = entry.value;
          final isSelected = _selectedAccount == account;
          final isLast = index == _availableAccounts.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () => setState(() => _selectedAccount = account),
                borderRadius: BorderRadius.circular(
                  index == 0 && isLast
                      ? 16
                      : (index == 0 ? 16 : (isLast ? 16 : 0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: account.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          account.icon,
                          color: account.color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              account.type,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.grey[400]
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey[400]!,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 70,
                  color: isDark ? const Color(0xFF334155) : Colors.grey[200],
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetailsList(
    BuildContext context,
    ContactModel contact,
    bool isDark,
  ) {
    final items = <_DetailItem>[
      if (contact.phone != null && contact.phone!.isNotEmpty)
        _DetailItem(
          Icons.phone_rounded,
          'Téléphone',
          contact.phone!,
          AppTheme.successColor,
        ),
      if (contact.email != null && contact.email!.isNotEmpty)
        _DetailItem(
          Icons.email_rounded,
          'Email',
          contact.email!,
          AppTheme.primaryColor,
        ),
      if (contact.company != null && contact.company!.isNotEmpty)
        _DetailItem(
          Icons.business_rounded,
          'Entreprise',
          contact.company!,
          AppTheme.warningColor,
        ),
      if (contact.jobTitle != null && contact.jobTitle!.isNotEmpty)
        _DetailItem(
          Icons.work_rounded,
          'Poste',
          contact.jobTitle!,
          Colors.purple,
        ),
      if (contact.website != null && contact.website!.isNotEmpty)
        _DetailItem(
          Icons.language_rounded,
          'Site web',
          contact.website!,
          Colors.teal,
        ),
      if (contact.address != null && contact.address!.isNotEmpty)
        _DetailItem(
          Icons.location_on_rounded,
          'Adresse',
          contact.address!,
          Colors.orange,
        ),
    ];

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Aucun détail disponible',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          final item = entry.value;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, size: 20, color: item.color),
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
                  ),
                ),
                subtitle: Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 72,
                  color: isDark ? const Color(0xFF334155) : Colors.grey[200],
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSaveButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSaving ? null : _saveContact,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save_rounded, color: Colors.white),
                      const SizedBox(width: 10),
                      const Text(
                        'Enregistrer le contact',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _AccountInfo {
  final String name;
  final String type;
  final IconData icon;
  final Color color;

  _AccountInfo({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _AccountInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => name.hashCode ^ type.hashCode;
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  _DetailItem(this.icon, this.label, this.value, this.color);
}
