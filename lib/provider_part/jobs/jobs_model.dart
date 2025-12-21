import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/job_item_cancelled/job_item_cancelled_widget.dart';
import '/provider_part/components_provider/job_item_completed/job_item_completed_widget.dart';
import '/provider_part/components_provider/job_item_in_progress/job_item_in_progress_widget.dart';
import '/provider_part/components_provider/job_item_upcoming/job_item_upcoming_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import 'dart:ui';
import 'jobs_widget.dart' show JobsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class JobsModel extends FlutterFlowModel<JobsWidget> {
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

  // Model for JobItem-Upcoming component.
  late JobItemUpcomingModel jobItemUpcomingModel1;
  // Model for JobItem-Upcoming component.
  late JobItemUpcomingModel jobItemUpcomingModel2;
  // Model for JobItem-Upcoming component.
  late JobItemUpcomingModel jobItemUpcomingModel3;
  // Model for JobItem-Upcoming component.
  late JobItemUpcomingModel jobItemUpcomingModel4;
  // Model for JobItem-InProgress component.
  late JobItemInProgressModel jobItemInProgressModel1;
  // Model for JobItem-InProgress component.
  late JobItemInProgressModel jobItemInProgressModel2;
  // Model for JobItem-InProgress component.
  late JobItemInProgressModel jobItemInProgressModel3;
  // Model for JobItem-InProgress component.
  late JobItemInProgressModel jobItemInProgressModel4;
  // Model for JobItem-Completed component.
  late JobItemCompletedModel jobItemCompletedModel1;
  // Model for JobItem-Completed component.
  late JobItemCompletedModel jobItemCompletedModel2;
  // Model for JobItem-Completed component.
  late JobItemCompletedModel jobItemCompletedModel3;
  // Model for JobItem-Completed component.
  late JobItemCompletedModel jobItemCompletedModel4;
  // Model for JobItem-Cancelled component.
  late JobItemCancelledModel jobItemCancelledModel1;
  // Model for JobItem-Cancelled component.
  late JobItemCancelledModel jobItemCancelledModel2;
  // Model for JobItem-Cancelled component.
  late JobItemCancelledModel jobItemCancelledModel3;
  // Model for JobItem-Cancelled component.
  late JobItemCancelledModel jobItemCancelledModel4;
  // Model for JobItem-Cancelled component.
  late JobItemCancelledModel jobItemCancelledModel5;

  @override
  void initState(BuildContext context) {
    messageBtnModel = createModel(context, () => MessageBtnModel());
    drawerContentModel = createModel(context, () => DrawerContentModel());
    jobItemUpcomingModel1 = createModel(context, () => JobItemUpcomingModel());
    jobItemUpcomingModel2 = createModel(context, () => JobItemUpcomingModel());
    jobItemUpcomingModel3 = createModel(context, () => JobItemUpcomingModel());
    jobItemUpcomingModel4 = createModel(context, () => JobItemUpcomingModel());
    jobItemInProgressModel1 =
        createModel(context, () => JobItemInProgressModel());
    jobItemInProgressModel2 =
        createModel(context, () => JobItemInProgressModel());
    jobItemInProgressModel3 =
        createModel(context, () => JobItemInProgressModel());
    jobItemInProgressModel4 =
        createModel(context, () => JobItemInProgressModel());
    jobItemCompletedModel1 =
        createModel(context, () => JobItemCompletedModel());
    jobItemCompletedModel2 =
        createModel(context, () => JobItemCompletedModel());
    jobItemCompletedModel3 =
        createModel(context, () => JobItemCompletedModel());
    jobItemCompletedModel4 =
        createModel(context, () => JobItemCompletedModel());
    jobItemCancelledModel1 =
        createModel(context, () => JobItemCancelledModel());
    jobItemCancelledModel2 =
        createModel(context, () => JobItemCancelledModel());
    jobItemCancelledModel3 =
        createModel(context, () => JobItemCancelledModel());
    jobItemCancelledModel4 =
        createModel(context, () => JobItemCancelledModel());
    jobItemCancelledModel5 =
        createModel(context, () => JobItemCancelledModel());
  }

  @override
  void dispose() {
    messageBtnModel.dispose();
    drawerContentModel.dispose();
    tabBarController?.dispose();
    jobItemUpcomingModel1.dispose();
    jobItemUpcomingModel2.dispose();
    jobItemUpcomingModel3.dispose();
    jobItemUpcomingModel4.dispose();
    jobItemInProgressModel1.dispose();
    jobItemInProgressModel2.dispose();
    jobItemInProgressModel3.dispose();
    jobItemInProgressModel4.dispose();
    jobItemCompletedModel1.dispose();
    jobItemCompletedModel2.dispose();
    jobItemCompletedModel3.dispose();
    jobItemCompletedModel4.dispose();
    jobItemCancelledModel1.dispose();
    jobItemCancelledModel2.dispose();
    jobItemCancelledModel3.dispose();
    jobItemCancelledModel4.dispose();
    jobItemCancelledModel5.dispose();
  }
}
