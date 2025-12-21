import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'like_icon_model.dart';
export 'like_icon_model.dart';

class LikeIconWidget extends StatefulWidget {
  const LikeIconWidget({
    super.key,
    required this.color,
  });

  final Color? color;

  @override
  State<LikeIconWidget> createState() => _LikeIconWidgetState();
}

class _LikeIconWidgetState extends State<LikeIconWidget> {
  late LikeIconModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LikeIconModel());
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
        if (_model.like)
          FlutterFlowIconButton(
            borderRadius: 30.0,
            buttonSize: 40.0,
            icon: Icon(
              FFIcons.kheart04,
              color: widget!.color,
              size: 22.0,
            ),
            onPressed: () async {
              _model.like = false;
              _model.updatePage(() {});
            },
          ),
        if (!_model.like)
          FlutterFlowIconButton(
            borderRadius: 30.0,
            buttonSize: 40.0,
            icon: Icon(
              FFIcons.kheart3,
              color: widget!.color,
              size: 22.0,
            ),
            onPressed: () async {
              _model.like = true;
              _model.updatePage(() {});
            },
          ),
      ],
    );
  }
}
