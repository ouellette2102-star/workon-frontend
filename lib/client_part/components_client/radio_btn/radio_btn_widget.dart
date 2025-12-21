import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'radio_btn_model.dart';
export 'radio_btn_model.dart';

class RadioBtnWidget extends StatefulWidget {
  const RadioBtnWidget({super.key});

  @override
  State<RadioBtnWidget> createState() => _RadioBtnWidgetState();
}

class _RadioBtnWidgetState extends State<RadioBtnWidget> {
  late RadioBtnModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RadioBtnModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_model.isChecked)
          FlutterFlowIconButton(
            borderRadius: 30.0,
            buttonSize: 40.0,
            icon: Icon(
              Icons.radio_button_off,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 22.0,
            ),
            onPressed: () async {
              _model.isChecked = true;
              _model.updatePage(() {});
            },
          ),
        if (_model.isChecked)
          FlutterFlowIconButton(
            borderRadius: 30.0,
            buttonSize: 40.0,
            icon: Icon(
              Icons.radio_button_checked,
              color: FlutterFlowTheme.of(context).primary,
              size: 22.0,
            ),
            onPressed: () async {
              _model.isChecked = false;
              _model.updatePage(() {});
            },
          ),
      ],
    );
  }
}
