import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/job_request_item/job_request_item_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import 'dart:ui';
import 'job_requests_widget.dart' show JobRequestsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class JobRequestsModel extends FlutterFlowModel<JobRequestsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MessageBtn component.
  late MessageBtnModel messageBtnModel;
  // Model for DrawerContent component.
  late DrawerContentModel drawerContentModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for SearchJobRequest widget.
  FocusNode? searchJobRequestFocusNode;
  TextEditingController? searchJobRequestTextController;
  String? Function(BuildContext, String?)?
      searchJobRequestTextControllerValidator;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel1;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel2;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel3;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel4;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel5;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel6;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel7;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel8;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel9;
  // Model for JobRequestItem component.
  late JobRequestItemModel jobRequestItemModel10;

  @override
  void initState(BuildContext context) {
    messageBtnModel = createModel(context, () => MessageBtnModel());
    drawerContentModel = createModel(context, () => DrawerContentModel());
    jobRequestItemModel1 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel2 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel3 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel4 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel5 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel6 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel7 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel8 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel9 = createModel(context, () => JobRequestItemModel());
    jobRequestItemModel10 = createModel(context, () => JobRequestItemModel());
  }

  @override
  void dispose() {
    messageBtnModel.dispose();
    drawerContentModel.dispose();
    tabBarController?.dispose();
    searchJobRequestFocusNode?.dispose();
    searchJobRequestTextController?.dispose();

    jobRequestItemModel1.dispose();
    jobRequestItemModel2.dispose();
    jobRequestItemModel3.dispose();
    jobRequestItemModel4.dispose();
    jobRequestItemModel5.dispose();
    jobRequestItemModel6.dispose();
    jobRequestItemModel7.dispose();
    jobRequestItemModel8.dispose();
    jobRequestItemModel9.dispose();
    jobRequestItemModel10.dispose();
  }
}
