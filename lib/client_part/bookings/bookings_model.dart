import '/client_part/components_client/booking_item_cancelled/booking_item_cancelled_widget.dart';
import '/client_part/components_client/booking_item_completed/booking_item_completed_widget.dart';
import '/client_part/components_client/booking_item_upcoming/booking_item_upcoming_widget.dart';
import '/client_part/components_client/mig_nav_bar/mig_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'bookings_widget.dart' show BookingsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookingsModel extends FlutterFlowModel<BookingsWidget> {
  ///  Local state fields for this page.

  String view = 'bookings';

  ///  State fields for stateful widgets in this page.

  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;
  // Model for BookingItem-Upcoming component.
  late BookingItemUpcomingModel bookingItemUpcomingModel1;
  // Model for BookingItem-Upcoming component.
  late BookingItemUpcomingModel bookingItemUpcomingModel2;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for BookingItem-Upcoming component.
  late BookingItemUpcomingModel bookingItemUpcomingModel3;
  // Model for BookingItem-Upcoming component.
  late BookingItemUpcomingModel bookingItemUpcomingModel4;
  // Model for BookingItem-Upcoming component.
  late BookingItemUpcomingModel bookingItemUpcomingModel5;
  // Model for BookingItem-Upcoming component.
  late BookingItemUpcomingModel bookingItemUpcomingModel6;
  // Model for BookingItem-Completed component.
  late BookingItemCompletedModel bookingItemCompletedModel1;
  // Model for BookingItem-Completed component.
  late BookingItemCompletedModel bookingItemCompletedModel2;
  // Model for BookingItem-Completed component.
  late BookingItemCompletedModel bookingItemCompletedModel3;
  // Model for BookingItem-Completed component.
  late BookingItemCompletedModel bookingItemCompletedModel4;
  // Model for BookingItem-Cancelled component.
  late BookingItemCancelledModel bookingItemCancelledModel1;
  // Model for BookingItem-Cancelled component.
  late BookingItemCancelledModel bookingItemCancelledModel2;
  // Model for BookingItem-Cancelled component.
  late BookingItemCancelledModel bookingItemCancelledModel3;
  // Model for BookingItem-Cancelled component.
  late BookingItemCancelledModel bookingItemCancelledModel4;
  // Model for MigNavBar component.
  late MigNavBarModel migNavBarModel;

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    bookingItemUpcomingModel1 =
        createModel(context, () => BookingItemUpcomingModel());
    bookingItemUpcomingModel2 =
        createModel(context, () => BookingItemUpcomingModel());
    bookingItemUpcomingModel3 =
        createModel(context, () => BookingItemUpcomingModel());
    bookingItemUpcomingModel4 =
        createModel(context, () => BookingItemUpcomingModel());
    bookingItemUpcomingModel5 =
        createModel(context, () => BookingItemUpcomingModel());
    bookingItemUpcomingModel6 =
        createModel(context, () => BookingItemUpcomingModel());
    bookingItemCompletedModel1 =
        createModel(context, () => BookingItemCompletedModel());
    bookingItemCompletedModel2 =
        createModel(context, () => BookingItemCompletedModel());
    bookingItemCompletedModel3 =
        createModel(context, () => BookingItemCompletedModel());
    bookingItemCompletedModel4 =
        createModel(context, () => BookingItemCompletedModel());
    bookingItemCancelledModel1 =
        createModel(context, () => BookingItemCancelledModel());
    bookingItemCancelledModel2 =
        createModel(context, () => BookingItemCancelledModel());
    bookingItemCancelledModel3 =
        createModel(context, () => BookingItemCancelledModel());
    bookingItemCancelledModel4 =
        createModel(context, () => BookingItemCancelledModel());
    migNavBarModel = createModel(context, () => MigNavBarModel());
  }

  @override
  void dispose() {
    bookingItemUpcomingModel1.dispose();
    bookingItemUpcomingModel2.dispose();
    tabBarController?.dispose();
    bookingItemUpcomingModel3.dispose();
    bookingItemUpcomingModel4.dispose();
    bookingItemUpcomingModel5.dispose();
    bookingItemUpcomingModel6.dispose();
    bookingItemCompletedModel1.dispose();
    bookingItemCompletedModel2.dispose();
    bookingItemCompletedModel3.dispose();
    bookingItemCompletedModel4.dispose();
    bookingItemCancelledModel1.dispose();
    bookingItemCancelledModel2.dispose();
    bookingItemCancelledModel3.dispose();
    bookingItemCancelledModel4.dispose();
    migNavBarModel.dispose();
  }
}
