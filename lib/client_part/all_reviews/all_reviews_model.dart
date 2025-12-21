import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/ratings_summary/ratings_summary_widget.dart';
import '/client_part/components_client/review_item/review_item_widget.dart';
import '/client_part/components_client/search_btn/search_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'all_reviews_widget.dart' show AllReviewsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AllReviewsModel extends FlutterFlowModel<AllReviewsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // Model for SearchBtn component.
  late SearchBtnModel searchBtnModel;
  // Model for RatingsSummary component.
  late RatingsSummaryModel ratingsSummaryModel;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel1;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel2;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel3;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel4;
  // Model for ReviewItem component.
  late ReviewItemModel reviewItemModel5;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    searchBtnModel = createModel(context, () => SearchBtnModel());
    ratingsSummaryModel = createModel(context, () => RatingsSummaryModel());
    reviewItemModel1 = createModel(context, () => ReviewItemModel());
    reviewItemModel2 = createModel(context, () => ReviewItemModel());
    reviewItemModel3 = createModel(context, () => ReviewItemModel());
    reviewItemModel4 = createModel(context, () => ReviewItemModel());
    reviewItemModel5 = createModel(context, () => ReviewItemModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    searchBtnModel.dispose();
    ratingsSummaryModel.dispose();
    reviewItemModel1.dispose();
    reviewItemModel2.dispose();
    reviewItemModel3.dispose();
    reviewItemModel4.dispose();
    reviewItemModel5.dispose();
  }
}
