import '/client_part/components_client/ratings_summary/ratings_summary_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/provider_part/components_provider/drawer_content/drawer_content_widget.dart';
import '/provider_part/components_provider/message_btn/message_btn_widget.dart';
import '/provider_part/components_provider/review_item_provider/review_item_provider_widget.dart';
import 'dart:ui';
import 'ratings_widget.dart' show RatingsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RatingsModel extends FlutterFlowModel<RatingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MessageBtn component.
  late MessageBtnModel messageBtnModel;
  // Model for DrawerContent component.
  late DrawerContentModel drawerContentModel;
  // Model for RatingsSummary component.
  late RatingsSummaryModel ratingsSummaryModel;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;
  // Model for ReviewItem-Provider component.
  late ReviewItemProviderModel reviewItemProviderModel1;
  // Model for ReviewItem-Provider component.
  late ReviewItemProviderModel reviewItemProviderModel2;
  // Model for ReviewItem-Provider component.
  late ReviewItemProviderModel reviewItemProviderModel3;
  // Model for ReviewItem-Provider component.
  late ReviewItemProviderModel reviewItemProviderModel4;
  // Model for ReviewItem-Provider component.
  late ReviewItemProviderModel reviewItemProviderModel5;

  @override
  void initState(BuildContext context) {
    messageBtnModel = createModel(context, () => MessageBtnModel());
    drawerContentModel = createModel(context, () => DrawerContentModel());
    ratingsSummaryModel = createModel(context, () => RatingsSummaryModel());
    reviewItemProviderModel1 =
        createModel(context, () => ReviewItemProviderModel());
    reviewItemProviderModel2 =
        createModel(context, () => ReviewItemProviderModel());
    reviewItemProviderModel3 =
        createModel(context, () => ReviewItemProviderModel());
    reviewItemProviderModel4 =
        createModel(context, () => ReviewItemProviderModel());
    reviewItemProviderModel5 =
        createModel(context, () => ReviewItemProviderModel());
  }

  @override
  void dispose() {
    messageBtnModel.dispose();
    drawerContentModel.dispose();
    ratingsSummaryModel.dispose();
    reviewItemProviderModel1.dispose();
    reviewItemProviderModel2.dispose();
    reviewItemProviderModel3.dispose();
    reviewItemProviderModel4.dispose();
    reviewItemProviderModel5.dispose();
  }
}
