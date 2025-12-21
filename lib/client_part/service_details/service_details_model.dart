import '/client_part/components_client/ratings_summary/ratings_summary_widget.dart';
import '/client_part/components_client/read_more_text/read_more_text_widget.dart';
import '/client_part/components_client/review_item/review_item_widget.dart';
import '/client_part/components_client/service_item2/service_item2_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'service_details_widget.dart' show ServiceDetailsWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ServiceDetailsModel extends FlutterFlowModel<ServiceDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ReadMoreText component.
  late ReadMoreTextModel readMoreTextModel;
  // Model for RatingsSummary component.
  late RatingsSummaryModel ratingsSummaryModel;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel1;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel2;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model1;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model2;
  // Model for ServiceItem2 component.
  late ServiceItem2Model serviceItem2Model3;

  @override
  void initState(BuildContext context) {
    readMoreTextModel = createModel(context, () => ReadMoreTextModel());
    ratingsSummaryModel = createModel(context, () => RatingsSummaryModel());
    reviewItemModel1 = createModel(context, () => ReviewItemModel());
    reviewItemModel2 = createModel(context, () => ReviewItemModel());
    serviceItem2Model1 = createModel(context, () => ServiceItem2Model());
    serviceItem2Model2 = createModel(context, () => ServiceItem2Model());
    serviceItem2Model3 = createModel(context, () => ServiceItem2Model());
  }

  @override
  void dispose() {
    readMoreTextModel.dispose();
    ratingsSummaryModel.dispose();
    reviewItemModel1.dispose();
    reviewItemModel2.dispose();
    serviceItem2Model1.dispose();
    serviceItem2Model2.dispose();
    serviceItem2Model3.dispose();
  }
}
