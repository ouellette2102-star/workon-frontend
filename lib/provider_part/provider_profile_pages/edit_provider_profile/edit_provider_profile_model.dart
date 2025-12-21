import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'edit_provider_profile_widget.dart' show EditProviderProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class EditProviderProfileModel
    extends FlutterFlowModel<EditProviderProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for Name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  // State field(s) for Bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  String? Function(BuildContext, String?)? bioTextControllerValidator;
  // State field(s) for PhoneNumber widget.
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberTextController;
  late MaskTextInputFormatter phoneNumberMask;
  String? Function(BuildContext, String?)? phoneNumberTextControllerValidator;
  // State field(s) for ExperienceYears widget.
  FocusNode? experienceYearsFocusNode;
  TextEditingController? experienceYearsTextController;
  String? Function(BuildContext, String?)?
      experienceYearsTextControllerValidator;
  // State field(s) for NewLanguage widget.
  FocusNode? newLanguageFocusNode;
  TextEditingController? newLanguageTextController;
  String? Function(BuildContext, String?)? newLanguageTextControllerValidator;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    bioFocusNode?.dispose();
    bioTextController?.dispose();

    phoneNumberFocusNode?.dispose();
    phoneNumberTextController?.dispose();

    experienceYearsFocusNode?.dispose();
    experienceYearsTextController?.dispose();

    newLanguageFocusNode?.dispose();
    newLanguageTextController?.dispose();
  }
}
