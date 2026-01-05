import 'package:flutter/material.dart';
import 'package:s_contact/core/theme.dart';
import 'package:s_contact/models/contact_model.dart';

/// Modern, professional contact form with clean design
class ContactForm extends StatefulWidget {
  final ContactModel? initialContact;
  final Future<bool> Function(ContactModel) onSave;
  final String? title;

  const ContactForm({
    super.key,
    this.initialContact,
    required this.onSave,
    this.title,
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _companyController;
  late TextEditingController _jobTitleController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.initialContact != null) {
      _populateControllers(widget.initialContact!);
    }
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _companyController = TextEditingController();
    _jobTitleController = TextEditingController();
    _addressController = TextEditingController();
    _websiteController = TextEditingController();
    _noteController = TextEditingController();
  }

  void _populateControllers(ContactModel contact) {
    _firstNameController.text = contact.firstName ?? '';
    _lastNameController.text = contact.lastName ?? '';
    _phoneController.text = contact.phone ?? '';
    _emailController.text = contact.email ?? '';
    _companyController.text = contact.company ?? '';
    _jobTitleController.text = contact.jobTitle ?? '';
    _addressController.text = contact.address ?? '';
    _websiteController.text = contact.website ?? '';
    _noteController.text = contact.note ?? '';
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;

    setState(() => _isSaving = true);

    // Build full name from first + last
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

    final contact = ContactModel(
      id: widget.initialContact?.id,
      name: fullName,
      firstName: firstName.isNotEmpty ? firstName : null,
      lastName: lastName.isNotEmpty ? lastName : null,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : null,
      company: _companyController.text.trim().isNotEmpty
          ? _companyController.text.trim()
          : null,
      jobTitle: _jobTitleController.text.trim().isNotEmpty
          ? _jobTitleController.text.trim()
          : null,
      address: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : null,
      website: _websiteController.text.trim().isNotEmpty
          ? _websiteController.text.trim()
          : null,
      note: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null,
    );

    try {
      final success = await widget.onSave(contact);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  widget.initialContact != null
                      ? 'Profil mis à jour'
                      : 'Profil créé',
                ),
              ],
            ),
            backgroundColor: AppTheme.primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Name Fields
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _firstNameController,
                  label: 'Prénom',
                  icon: Icons.person_outline_rounded,
                  isDark: isDark,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _lastNameController,
                  label: 'Nom',
                  icon: Icons.person_outline_rounded,
                  isDark: isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _phoneController,
            label: 'Téléphone',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Divider
          Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),

          const SizedBox(height: 24),

          _buildTextField(
            controller: _companyController,
            label: 'Entreprise',
            icon: Icons.business_outlined,
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _jobTitleController,
            label: 'Poste',
            icon: Icons.work_outline_rounded,
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _addressController,
            label: 'Adresse',
            icon: Icons.location_on_outlined,
            isDark: isDark,
            maxLines: 2,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _websiteController,
            label: 'Site web',
            icon: Icons.language_rounded,
            keyboardType: TextInputType.url,
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _noteController,
            label: 'Notes',
            icon: Icons.notes_rounded,
            isDark: isDark,
            maxLines: 3,
          ),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.initialContact != null ? 'Enregistrer' : 'Créer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isDark,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        color: isDark ? Colors.white : AppTheme.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null
            ? Icon(
                icon,
                size: 20,
                color: AppTheme.primaryColor.withValues(alpha: 0.7),
              )
            : null,
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : Colors.grey[200]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.errorColor, width: 1),
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: isRequired
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ce champ est requis';
              }
              return null;
            }
          : null,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
