import 'package:flutter/material.dart';
import 'package:s_contact/core/theme.dart';
import 'package:s_contact/models/contact_model.dart';

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

  late TextEditingController _nameController;
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
    _nameController = TextEditingController();
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
    _nameController.text = contact.name;
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
    if (!_formKey.currentState!.validate()) return;

    final contact = ContactModel(
      id: widget.initialContact?.id,
      name: _nameController.text.trim(),
      firstName: _firstNameController.text.trim().isNotEmpty
          ? _firstNameController.text.trim()
          : null,
      lastName: _lastNameController.text.trim().isNotEmpty
          ? _lastNameController.text.trim()
          : null,
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
            content: Text(widget.initialContact != null
                ? 'Profil mis à jour avec succès !'
                : 'Profil créé avec succès !'),
            backgroundColor: const Color(0xFF10B981), // Vert succès
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: const Color(0xFFEF4444), // Rouge erreur
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre si fourni
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Nom complet
          TextFormField(
            controller: _nameController,
            decoration: _buildInputDecoration(context, 'Nom complet', 'Ex: Kokou KODJO', Icons.person),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le nom est obligatoire';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Prénom et nom séparés
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: _buildInputDecoration(context, 'Prénom', 'Kokou'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: _buildInputDecoration(context, 'Nom', 'KODJO'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Téléphone
          TextFormField(
            controller: _phoneController,
            decoration: _buildInputDecoration(context, 'Téléphone', '+228 90 00 00 00', Icons.phone),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final phoneRegex = RegExp(r'^[+]?[\d\s\-\(\)]+$');
                if (!phoneRegex.hasMatch(value)) {
                  return 'Format de téléphone invalide';
                }
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: _emailController,
            decoration: _buildInputDecoration(context, 'Email', 'kokou.kodjo@email.com', Icons.email),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Format d\'email invalide';
                }
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Entreprise
          TextFormField(
            controller: _companyController,
            decoration: _buildInputDecoration(context, 'Entreprise', 'Togocom, Ecobank, etc.', Icons.business),
          ),

          const SizedBox(height: 16),

          // Poste
          TextFormField(
            controller: _jobTitleController,
            decoration: _buildInputDecoration(context, 'Poste', 'Développeur, Manager, etc.', Icons.work),
          ),

          const SizedBox(height: 16),

          // Adresse
          TextFormField(
            controller: _addressController,
            decoration: _buildInputDecoration(context, 'Adresse', 'Agoè, Bè, Tokoin, Lomé', Icons.location_on),
            maxLines: 2,
          ),

          const SizedBox(height: 16),

          // Site web
          TextFormField(
            controller: _websiteController,
            decoration: _buildInputDecoration(context, 'Site web', 'https://example.com', Icons.language),
            keyboardType: TextInputType.url,
          ),

          const SizedBox(height: 16),

          // Note
          TextFormField(
            controller: _noteController,
            decoration: _buildInputDecoration(context, 'Note', 'Informations personnelles...', Icons.note),
            maxLines: 3,
          ),

          const SizedBox(height: 24),

          // Bouton de sauvegarde
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                widget.initialContact != null ? 'Mettre à jour' : 'Créer le profil',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String labelText, String hintText, [IconData? icon]) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppTheme.primaryColor,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
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
