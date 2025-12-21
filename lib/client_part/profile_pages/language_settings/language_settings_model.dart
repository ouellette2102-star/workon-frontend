import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/language_item/language_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'language_settings_widget.dart' show LanguageSettingsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LanguageSettingsModel extends FlutterFlowModel<LanguageSettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel1;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel2;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel3;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel4;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel5;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel6;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel7;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel8;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel9;
  // Model for LanguageItem component.
  late LanguageItemModel languageItemModel10;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    languageItemModel1 = createModel(context, () => LanguageItemModel());
    languageItemModel2 = createModel(context, () => LanguageItemModel());
    languageItemModel3 = createModel(context, () => LanguageItemModel());
    languageItemModel4 = createModel(context, () => LanguageItemModel());
    languageItemModel5 = createModel(context, () => LanguageItemModel());
    languageItemModel6 = createModel(context, () => LanguageItemModel());
    languageItemModel7 = createModel(context, () => LanguageItemModel());
    languageItemModel8 = createModel(context, () => LanguageItemModel());
    languageItemModel9 = createModel(context, () => LanguageItemModel());
    languageItemModel10 = createModel(context, () => LanguageItemModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    languageItemModel1.dispose();
    languageItemModel2.dispose();
    languageItemModel3.dispose();
    languageItemModel4.dispose();
    languageItemModel5.dispose();
    languageItemModel6.dispose();
    languageItemModel7.dispose();
    languageItemModel8.dispose();
    languageItemModel9.dispose();
    languageItemModel10.dispose();
  }
}
