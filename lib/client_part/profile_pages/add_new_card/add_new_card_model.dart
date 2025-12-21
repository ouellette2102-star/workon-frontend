import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'add_new_card_widget.dart' show AddNewCardWidget;
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class AddNewCardModel extends FlutterFlowModel<AddNewCardWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for CardHolderName widget.
  FocusNode? cardHolderNameFocusNode;
  TextEditingController? cardHolderNameTextController;
  String? Function(BuildContext, String?)?
      cardHolderNameTextControllerValidator;
  // State field(s) for CardNumber widget.
  FocusNode? cardNumberFocusNode;
  TextEditingController? cardNumberTextController;
  late MaskTextInputFormatter cardNumberMask;
  String? Function(BuildContext, String?)? cardNumberTextControllerValidator;
  // State field(s) for CardExpryDate widget.
  FocusNode? cardExpryDateFocusNode;
  TextEditingController? cardExpryDateTextController;
  late MaskTextInputFormatter cardExpryDateMask;
  String? Function(BuildContext, String?)? cardExpryDateTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for CardCVV widget.
  FocusNode? cardCVVFocusNode;
  TextEditingController? cardCVVTextController;
  late bool cardCVVVisibility;
  String? Function(BuildContext, String?)? cardCVVTextControllerValidator;

  @override
  void initState(BuildContext context) {
    cardCVVVisibility = false;
  }

  @override
  void dispose() {
    cardHolderNameFocusNode?.dispose();
    cardHolderNameTextController?.dispose();

    cardNumberFocusNode?.dispose();
    cardNumberTextController?.dispose();

    cardExpryDateFocusNode?.dispose();
    cardExpryDateTextController?.dispose();

    cardCVVFocusNode?.dispose();
    cardCVVTextController?.dispose();
  }
}
