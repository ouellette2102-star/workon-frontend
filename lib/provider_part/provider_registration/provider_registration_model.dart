import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/success_widget/success_widget_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/provider_part/components_provider/availability_item/availability_item_widget.dart';
import '/provider_part/components_provider/configure_service/configure_service_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'provider_registration_widget.dart' show ProviderRegistrationWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ProviderRegistrationModel
    extends FlutterFlowModel<ProviderRegistrationWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for Name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  // State field(s) for Email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for PhoneNumber widget.
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberTextController;
  late MaskTextInputFormatter phoneNumberMask;
  String? Function(BuildContext, String?)? phoneNumberTextControllerValidator;
  // State field(s) for DateOfBirth widget.
  FocusNode? dateOfBirthFocusNode;
  TextEditingController? dateOfBirthTextController;
  late MaskTextInputFormatter dateOfBirthMask;
  String? Function(BuildContext, String?)? dateOfBirthTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for Gender widget.
  String? genderValue;
  FormFieldController<String>? genderValueController;
  // State field(s) for DocumentType widget.
  String? documentTypeValue;
  FormFieldController<String>? documentTypeValueController;
  bool isDataUploading_uploadDataW82 = false;
  FFUploadedFile uploadedLocalFile_uploadDataW82 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for SearchPlace widget.
  FocusNode? searchPlaceFocusNode;
  TextEditingController? searchPlaceTextController;
  String? Function(BuildContext, String?)? searchPlaceTextControllerValidator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for Checkbox widget.
  bool? checkboxValue2;
  // State field(s) for Checkbox widget.
  bool? checkboxValue3;
  // State field(s) for Checkbox widget.
  bool? checkboxValue4;
  // State field(s) for Checkbox widget.
  bool? checkboxValue5;
  // State field(s) for Checkbox widget.
  bool? checkboxValue6;
  // State field(s) for Checkbox widget.
  bool? checkboxValue7;
  // State field(s) for SearchService widget.
  FocusNode? searchServiceFocusNode;
  TextEditingController? searchServiceTextController;
  String? Function(BuildContext, String?)? searchServiceTextControllerValidator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue8;
  // State field(s) for Checkbox widget.
  bool? checkboxValue9;
  // State field(s) for Checkbox widget.
  bool? checkboxValue10;
  // State field(s) for Checkbox widget.
  bool? checkboxValue11;
  // State field(s) for Checkbox widget.
  bool? checkboxValue12;
  // State field(s) for Checkbox widget.
  bool? checkboxValue13;
  // State field(s) for Checkbox widget.
  bool? checkboxValue14;
  // State field(s) for Checkbox widget.
  bool? checkboxValue15;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel1;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel2;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel3;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel4;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel5;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel6;
  // Model for AvailabilityItem component.
  late AvailabilityItemModel availabilityItemModel7;
  // State field(s) for SearchBank widget.
  FocusNode? searchBankFocusNode;
  TextEditingController? searchBankTextController;
  String? Function(BuildContext, String?)? searchBankTextControllerValidator;
  // State field(s) for AccountHolderName widget.
  FocusNode? accountHolderNameFocusNode;
  TextEditingController? accountHolderNameTextController;
  String? Function(BuildContext, String?)?
      accountHolderNameTextControllerValidator;
  // State field(s) for AccountNumber widget.
  FocusNode? accountNumberFocusNode;
  TextEditingController? accountNumberTextController;
  String? Function(BuildContext, String?)? accountNumberTextControllerValidator;
  // State field(s) for ReasonToJoin widget.
  FocusNode? reasonToJoinFocusNode;
  TextEditingController? reasonToJoinTextController;
  String? Function(BuildContext, String?)? reasonToJoinTextControllerValidator;
  // Model for SuccessWidget component.
  late SuccessWidgetModel successWidgetModel;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
    availabilityItemModel1 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel2 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel3 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel4 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel5 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel6 =
        createModel(context, () => AvailabilityItemModel());
    availabilityItemModel7 =
        createModel(context, () => AvailabilityItemModel());
    successWidgetModel = createModel(context, () => SuccessWidgetModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    phoneNumberFocusNode?.dispose();
    phoneNumberTextController?.dispose();

    dateOfBirthFocusNode?.dispose();
    dateOfBirthTextController?.dispose();

    searchPlaceFocusNode?.dispose();
    searchPlaceTextController?.dispose();

    searchServiceFocusNode?.dispose();
    searchServiceTextController?.dispose();

    availabilityItemModel1.dispose();
    availabilityItemModel2.dispose();
    availabilityItemModel3.dispose();
    availabilityItemModel4.dispose();
    availabilityItemModel5.dispose();
    availabilityItemModel6.dispose();
    availabilityItemModel7.dispose();
    searchBankFocusNode?.dispose();
    searchBankTextController?.dispose();

    accountHolderNameFocusNode?.dispose();
    accountHolderNameTextController?.dispose();

    accountNumberFocusNode?.dispose();
    accountNumberTextController?.dispose();

    reasonToJoinFocusNode?.dispose();
    reasonToJoinTextController?.dispose();

    successWidgetModel.dispose();
  }
}
