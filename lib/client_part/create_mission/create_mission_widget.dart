/// Create Mission Screen - Employer Flow v1
///
/// Allows employers to create new missions.
/// Calls POST /api/v1/missions-local.
///
/// **PR-F20:** Employer Flow - Create Mission.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/config/app_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/services/missions/missions_service.dart';
import '/services/missions/mission_models.dart';
import '/services/location/location_service.dart';

/// Categories available for missions.
const List<String> _categories = [
  'cleaning',
  'snow_removal',
  'lawn_care',
  'moving',
  'handyman',
  'painting',
  'plumbing',
  'electrical',
  'other',
];

/// Category display names (French).
const Map<String, String> _categoryNames = {
  'cleaning': 'Ménage',
  'snow_removal': 'Déneigement',
  'lawn_care': 'Entretien pelouse',
  'moving': 'Déménagement',
  'handyman': 'Bricolage',
  'painting': 'Peinture',
  'plumbing': 'Plomberie',
  'electrical': 'Électricité',
  'other': 'Autre',
};

class CreateMissionWidget extends StatefulWidget {
  const CreateMissionWidget({super.key});

  static String routeName = 'CreateMission';
  static String routePath = '/create-mission';

  @override
  State<CreateMissionWidget> createState() => _CreateMissionWidgetState();
}

class _CreateMissionWidgetState extends State<CreateMissionWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedCategory = 'cleaning';
  bool _isLoading = false;
  String? _errorMessage;

  // Location - defaults to Montreal
  double _latitude = AppConfig.defaultMapLat;
  double _longitude = AppConfig.defaultMapLng;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  /// Initialize location from device or use default.
  Future<void> _initLocation() async {
    try {
      final status = await LocationService.instance.checkAndRequestPermission();
      if (status == LocationPermissionStatus.granted) {
        final position = await LocationService.instance.getCurrentPosition();
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
        debugPrint('[CreateMission] Using device location: $_latitude, $_longitude');
      } else {
        debugPrint('[CreateMission] Using default location (Montreal)');
      }
    } catch (e) {
      debugPrint('[CreateMission] Location error: $e - using default');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  /// Submit the mission creation form.
  Future<void> _submitMission() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final price = double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0;

      debugPrint('[CreateMission] Submitting mission...');
      debugPrint('[CreateMission] Title: ${_titleController.text}');
      debugPrint('[CreateMission] Category: $_selectedCategory');
      debugPrint('[CreateMission] Price: $price');
      debugPrint('[CreateMission] Location: $_latitude, $_longitude');

      final mission = await MissionsService.create(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        price: price,
        latitude: _latitude,
        longitude: _longitude,
        city: _cityController.text.trim().isNotEmpty 
            ? _cityController.text.trim() 
            : 'Montreal',
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : null,
      );

      debugPrint('[CreateMission] Mission created: ${mission.id}');

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mission créée avec succès!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate back or to mission detail
      Navigator.of(context).pop(mission);

    } catch (e) {
      debugPrint('[CreateMission] Error: $e');
      setState(() {
        _errorMessage = e.toString().replaceAll('MissionsApiException: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 0,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          buttonSize: 46,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Créer une mission',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'General Sans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                useGoogleFonts: false,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Title
                _buildLabel('Titre'),
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration('Ex: Déneigement entrée de garage'),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le titre est requis';
                    }
                    if (value.trim().length < 5) {
                      return 'Le titre doit avoir au moins 5 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                _buildLabel('Description'),
                TextFormField(
                  controller: _descriptionController,
                  decoration: _inputDecoration('Décrivez la mission en détail...'),
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La description est requise';
                    }
                    if (value.trim().length < 10) {
                      return 'La description doit avoir au moins 10 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category
                _buildLabel('Catégorie'),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: _inputDecoration(''),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(_categoryNames[cat] ?? cat),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Price
                _buildLabel('Prix (\$)'),
                TextFormField(
                  controller: _priceController,
                  decoration: _inputDecoration('Ex: 50.00'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le prix est requis';
                    }
                    final price = double.tryParse(value.replaceAll(',', '.'));
                    if (price == null || price <= 0) {
                      return 'Entrez un prix valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // City
                _buildLabel('Ville'),
                TextFormField(
                  controller: _cityController,
                  decoration: _inputDecoration('Ex: Montreal'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La ville est requise';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address (optional)
                _buildLabel('Adresse (optionnel)'),
                TextFormField(
                  controller: _addressController,
                  decoration: _inputDecoration('Ex: 123 Rue Example'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 8),

                // Location info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Position: ${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)}',
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit button
                FFButtonWidget(
                  onPressed: _isLoading ? null : _submitMission,
                  text: _isLoading ? 'Création...' : 'Publier la mission',
                  options: FFButtonOptions(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                // Loading indicator
                if (_isLoading) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: FlutterFlowTheme.of(context).labelMedium.override(
              fontFamily: 'General Sans',
              fontWeight: FontWeight.w600,
              useGoogleFonts: false,
            ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

