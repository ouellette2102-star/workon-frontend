import '/client_part/components_client/radio_btn/radio_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'radio_list_item_model.dart';
export 'radio_list_item_model.dart';

class RadioListItemWidget extends StatefulWidget {
  const RadioListItemWidget({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  State<RadioListItemWidget> createState() => _RadioListItemWidgetState();
}

class _RadioListItemWidgetState extends State<RadioListItemWidget> {
  late RadioListItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RadioListItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 10.0, 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            wrapWithModel(
              model: _model.radioBtnModel,
              updateCallback: () => safeSetState(() {}),
              child: RadioBtnWidget(),
            ),
            Flexible(
              child: Text(
                valueOrDefault<String>(
                  widget!.text,
                  'Text',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ].divide(SizedBox(width: 5.0)),
        ),
      ),
    );
  }
}
