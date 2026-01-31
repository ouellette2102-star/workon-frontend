/// Create support ticket page.
///
/// Form for creating a new support ticket.
///
/// **FL-SUPPORT:** Initial implementation.
library;

import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/support/support_models.dart';
import '/services/support/support_service.dart';
import '/services/support/support_api.dart';

/// Widget for creating a new support ticket.
class CreateTicketWidget extends StatefulWidget {
  const CreateTicketWidget({
    super.key,
    this.missionId,
    this.initialCategory,
  });

  /// Optional mission ID to link ticket to.
  final String? missionId;

  /// Optional initial category.
  final TicketCategory? initialCategory;

  @override
  State<CreateTicketWidget> createState() => _CreateTicketWidgetState();
}

class _CreateTicketWidgetState extends State<CreateTicketWidget> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  TicketCategory _category = TicketCategory.general;
  TicketPriority _priority = TicketPriority.medium;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _category = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await SupportService.createTicket(
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
        category: _category,
        priority: _priority,
        missionId: widget.missionId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket créé avec succès')),
        );
        Navigator.of(context).pop(true);
      }
    } on SupportApiException catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors de la création'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: theme.primaryText),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Nouvelle demande',
            style: theme.titleMedium.override(
              fontFamily: 'General Sans',
              letterSpacing: 0,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category selector
                  _buildLabel(theme, 'Catégorie'),
                  const SizedBox(height: 8),
                  _buildCategorySelector(theme),
                  const SizedBox(height: 20),

                  // Subject
                  _buildLabel(theme, 'Sujet'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _subjectController,
                    decoration: _inputDecoration(theme, 'Décrivez brièvement le problème'),
                    style: _inputStyle(theme),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer un sujet';
                      }
                      if (value.trim().length < 5) {
                        return 'Le sujet doit contenir au moins 5 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Message
                  _buildLabel(theme, 'Message'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _messageController,
                    decoration: _inputDecoration(
                      theme,
                      'Décrivez votre problème en détail...',
                    ),
                    style: _inputStyle(theme),
                    maxLines: 6,
                    minLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer un message';
                      }
                      if (value.trim().length < 20) {
                        return 'Le message doit contenir au moins 20 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Priority
                  _buildLabel(theme, 'Priorité'),
                  const SizedBox(height: 8),
                  _buildPrioritySelector(theme),
                  const SizedBox(height: 32),

                  // Submit button
                  FFButtonWidget(
                    onPressed: _isSubmitting ? null : _submitTicket,
                    text: _isSubmitting ? 'Envoi en cours...' : 'Envoyer',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 55,
                      color: _isSubmitting
                          ? theme.secondaryText.withOpacity(0.3)
                          : theme.primary,
                      textStyle: theme.titleSmall.override(
                        fontFamily: 'General Sans',
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(FlutterFlowTheme theme, String text) {
    return Text(
      text,
      style: theme.bodyMedium.override(
        fontFamily: 'General Sans',
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCategorySelector(FlutterFlowTheme theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TicketCategory.values.map((cat) {
        final isSelected = _category == cat;
        return ChoiceChip(
          label: Text(cat.displayName),
          selected: isSelected,
          onSelected: (_) => setState(() => _category = cat),
          selectedColor: theme.primary.withOpacity(0.2),
          backgroundColor: theme.secondaryBackground,
          labelStyle: theme.bodySmall.override(
            fontFamily: 'General Sans',
            color: isSelected ? theme.primary : theme.primaryText,
            letterSpacing: 0,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? theme.primary : Colors.transparent,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrioritySelector(FlutterFlowTheme theme) {
    return Row(
      children: TicketPriority.values.map((p) {
        final isSelected = _priority == p;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: p != TicketPriority.urgent ? 8 : 0,
            ),
            child: InkWell(
              onTap: () => setState(() => _priority = p),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getPriorityColor(theme, p).withOpacity(0.1)
                      : theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? _getPriorityColor(theme, p)
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getPriorityIcon(p),
                      color: isSelected
                          ? _getPriorityColor(theme, p)
                          : theme.secondaryText,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.displayName,
                      style: theme.bodySmall.override(
                        fontFamily: 'General Sans',
                        color: isSelected
                            ? _getPriorityColor(theme, p)
                            : theme.secondaryText,
                        letterSpacing: 0,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  InputDecoration _inputDecoration(FlutterFlowTheme theme, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: theme.bodyMedium.override(
        fontFamily: 'General Sans',
        color: theme.secondaryText,
        letterSpacing: 0,
      ),
      filled: true,
      fillColor: theme.secondaryBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.error),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  TextStyle _inputStyle(FlutterFlowTheme theme) {
    return theme.bodyMedium.override(
      fontFamily: 'General Sans',
      letterSpacing: 0,
    );
  }

  Color _getPriorityColor(FlutterFlowTheme theme, TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return theme.success;
      case TicketPriority.medium:
        return theme.warning;
      case TicketPriority.high:
        return theme.tertiary;
      case TicketPriority.urgent:
        return theme.error;
    }
  }

  IconData _getPriorityIcon(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return Icons.arrow_downward_rounded;
      case TicketPriority.medium:
        return Icons.remove_rounded;
      case TicketPriority.high:
        return Icons.arrow_upward_rounded;
      case TicketPriority.urgent:
        return Icons.priority_high_rounded;
    }
  }
}
