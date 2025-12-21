import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bookmark_icon_model.dart';
export 'bookmark_icon_model.dart';

class BookmarkIconWidget extends StatefulWidget {
  const BookmarkIconWidget({super.key});

  @override
  State<BookmarkIconWidget> createState() => _BookmarkIconWidgetState();
}

class _BookmarkIconWidgetState extends State<BookmarkIconWidget> {
  late BookmarkIconModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BookmarkIconModel());
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
        if (!_model.isAdded)
          FlutterFlowIconButton(
            borderRadius: 12.0,
            buttonSize: 40.0,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            icon: Icon(
              FFIcons.karchiveAdd1,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 22.0,
            ),
            onPressed: () async {
              _model.isAdded = true;
              safeSetState(() {});
            },
          ),
        if (_model.isAdded)
          FlutterFlowIconButton(
            borderRadius: 12.0,
            buttonSize: 40.0,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            icon: Icon(
              FFIcons.karchiveTick,
              color: FlutterFlowTheme.of(context).success,
              size: 22.0,
            ),
            onPressed: () async {
              _model.isAdded = false;
              safeSetState(() {});
            },
          ),
      ],
    );
  }
}
