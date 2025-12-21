import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/experience_item/experience_item_widget.dart';
import 'dart:ui';
import 'client_public_profile_widget.dart' show ClientPublicProfileWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ClientPublicProfileModel
    extends FlutterFlowModel<ClientPublicProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // Model for ExperienceItem component.
  late ExperienceItemModel experienceItemModel1;
  // Model for ExperienceItem component.
  late ExperienceItemModel experienceItemModel2;
  // Model for ExperienceItem component.
  late ExperienceItemModel experienceItemModel3;
  // Model for ExperienceItem component.
  late ExperienceItemModel experienceItemModel4;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    experienceItemModel1 = createModel(context, () => ExperienceItemModel());
    experienceItemModel2 = createModel(context, () => ExperienceItemModel());
    experienceItemModel3 = createModel(context, () => ExperienceItemModel());
    experienceItemModel4 = createModel(context, () => ExperienceItemModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    experienceItemModel1.dispose();
    experienceItemModel2.dispose();
    experienceItemModel3.dispose();
    experienceItemModel4.dispose();
  }
}
