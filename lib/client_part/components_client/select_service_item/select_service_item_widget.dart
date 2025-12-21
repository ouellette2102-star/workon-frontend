import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'select_service_item_model.dart';
export 'select_service_item_model.dart';

class SelectServiceItemWidget extends StatefulWidget {
  const SelectServiceItemWidget({super.key});

  @override
  State<SelectServiceItemWidget> createState() =>
      _SelectServiceItemWidgetState();
}

class _SelectServiceItemWidgetState extends State<SelectServiceItemWidget> {
  late SelectServiceItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectServiceItemModel());
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
        if (!_model.isSelected)
          FlutterFlowIconButton(
            borderColor: FlutterFlowTheme.of(context).primary,
            borderRadius: 12.0,
            borderWidth: 2.0,
            buttonSize: 30.0,
            icon: Icon(
              FFIcons.ktickSquare50,
              color: Colors.transparent,
              size: 20.0,
            ),
            onPressed: () async {
              _model.isSelected = true;
              _model.updatePage(() {});
            },
          ),
        if (_model.isSelected)
          FlutterFlowIconButton(
            borderRadius: 12.0,
            buttonSize: 30.0,
            fillColor: FlutterFlowTheme.of(context).primary,
            icon: Icon(
              Icons.done_rounded,
              color: FlutterFlowTheme.of(context).info,
              size: 15.0,
            ),
            onPressed: () async {
              _model.isSelected = false;
              _model.updatePage(() {});
            },
          ),
      ],
    );
  }
}
