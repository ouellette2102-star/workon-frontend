import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'back_icon_btn_model.dart';
export 'back_icon_btn_model.dart';

class BackIconBtnWidget extends StatefulWidget {
  const BackIconBtnWidget({super.key});

  @override
  State<BackIconBtnWidget> createState() => _BackIconBtnWidgetState();
}

class _BackIconBtnWidgetState extends State<BackIconBtnWidget> {
  late BackIconBtnModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BackIconBtnModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFlowIconButton(
      borderRadius: 14.0,
      buttonSize: 40.0,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      icon: Icon(
        FFIcons.karrowLeft281,
        color: FlutterFlowTheme.of(context).primaryText,
        size: 20.0,
      ),
      onPressed: () async {
        context.safePop();
      },
    );
  }
}
