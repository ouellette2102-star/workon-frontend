import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/failed_widget/failed_widget_widget.dart';
import '/client_part/components_client/success_widget/success_widget_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import '/services/ratings/ratings_service.dart';
import '/services/ratings/ratings_models.dart';
import 'leave_review_widget.dart' show LeaveReviewWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LeaveReviewModel extends FlutterFlowModel<LeaveReviewWidget> {
  ///  State fields for stateful widgets in this page.
  
  /// Loading state for API call.
  bool isLoading = false;
  
  /// Error message if API call fails.
  String? errorMessage;

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue1;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  List<String>? get choiceChipsValues1 => choiceChipsValueController1?.value;
  set choiceChipsValues1(List<String>? val) =>
      choiceChipsValueController1?.value = val;
  // State field(s) for ReviewMessage widget.
  FocusNode? reviewMessageFocusNode1;
  TextEditingController? reviewMessageTextController1;
  String? Function(BuildContext, String?)?
      reviewMessageTextController1Validator;
  // State field(s) for RatingBar widget.
  double? ratingBarValue2;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  List<String>? get choiceChipsValues2 => choiceChipsValueController2?.value;
  set choiceChipsValues2(List<String>? val) =>
      choiceChipsValueController2?.value = val;
  // State field(s) for ReviewMessage widget.
  FocusNode? reviewMessageFocusNode2;
  TextEditingController? reviewMessageTextController2;
  String? Function(BuildContext, String?)?
      reviewMessageTextController2Validator;
  // Model for SuccessWidget component.
  late SuccessWidgetModel successWidgetModel;
  // Model for FailedWidget component.
  late FailedWidgetModel failedWidgetModel;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    successWidgetModel = createModel(context, () => SuccessWidgetModel());
    failedWidgetModel = createModel(context, () => FailedWidgetModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    reviewMessageFocusNode1?.dispose();
    reviewMessageTextController1?.dispose();

    reviewMessageFocusNode2?.dispose();
    reviewMessageTextController2?.dispose();

    successWidgetModel.dispose();
    failedWidgetModel.dispose();
  }
  
  /// Submits the review to the backend API.
  /// Returns true on success, false on failure.
  Future<bool> submitReview({
    required String targetUserId,
    required double rating,
    String? missionId,
    String? comment,
    List<String>? tags,
  }) async {
    if (isLoading) return false;
    
    isLoading = true;
    errorMessage = null;
    
    try {
      // Build comment with tags if provided
      String? fullComment = comment;
      if (tags != null && tags.isNotEmpty) {
        final tagText = tags.join(', ');
        fullComment = comment?.isNotEmpty == true 
            ? '$comment\n\nTags: $tagText'
            : 'Tags: $tagText';
      }
      
      await RatingsService.createReview(
        toUserId: targetUserId,
        rating: rating.round(),
        missionId: missionId,
        comment: fullComment,
        tags: tags,
      );
      
      isLoading = false;
      return true;
    } catch (e) {
      if (e.toString().contains('déjà laissé')) {
        errorMessage = 'Vous avez déjà laissé un avis pour cet utilisateur.';
      } else {
        errorMessage = 'Une erreur est survenue. Réessayez plus tard.';
      }
      isLoading = false;
      return false;
    }
  }
}
