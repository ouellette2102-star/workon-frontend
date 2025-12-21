import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'add_new_address_widget.dart' show AddNewAddressWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class AddNewAddressModel extends FlutterFlowModel<AddNewAddressWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BackIconBtn component.
  late BackIconBtnModel backIconBtnModel;
  // State field(s) for Name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  // State field(s) for Province widget.
  String? provinceValue;
  FormFieldController<String>? provinceValueController;
  // State field(s) for District widget.
  FocusNode? districtFocusNode;
  TextEditingController? districtTextController;
  String? Function(BuildContext, String?)? districtTextControllerValidator;
  // State field(s) for PlaceName widget.
  FocusNode? placeNameFocusNode;
  TextEditingController? placeNameTextController;
  String? Function(BuildContext, String?)? placeNameTextControllerValidator;
  // State field(s) for PhoneNumber widget.
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberTextController;
  late MaskTextInputFormatter phoneNumberMask;
  String? Function(BuildContext, String?)? phoneNumberTextControllerValidator;
  // State field(s) for Label widget.
  FocusNode? labelFocusNode;
  TextEditingController? labelTextController;
  String? Function(BuildContext, String?)? labelTextControllerValidator;

  @override
  void initState(BuildContext context) {
    backIconBtnModel = createModel(context, () => BackIconBtnModel());
  }

  @override
  void dispose() {
    backIconBtnModel.dispose();
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    districtFocusNode?.dispose();
    districtTextController?.dispose();

    placeNameFocusNode?.dispose();
    placeNameTextController?.dispose();

    phoneNumberFocusNode?.dispose();
    phoneNumberTextController?.dispose();

    labelFocusNode?.dispose();
    labelTextController?.dispose();
  }
}
