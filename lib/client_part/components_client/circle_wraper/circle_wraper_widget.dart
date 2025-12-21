import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'circle_wraper_model.dart';
export 'circle_wraper_model.dart';

class CircleWraperWidget extends StatefulWidget {
  const CircleWraperWidget({
    super.key,
    required this.icon,
    required this.color,
  });

  final Widget? icon;
  final Color? color;

  @override
  State<CircleWraperWidget> createState() => _CircleWraperWidgetState();
}

class _CircleWraperWidgetState extends State<CircleWraperWidget> {
  late CircleWraperModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CircleWraperModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                color: widget!.color,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: widget!.icon!,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.77, -0.78),
            child: Container(
              width: 25.0,
              height: 25.0,
              decoration: BoxDecoration(
                color: widget!.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.73, -0.59),
            child: Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: widget!.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.62, 0.36),
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: widget!.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.22, 0.9),
            child: Container(
              width: 5.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: widget!.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.41, 0.91),
            child: Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                color: widget!.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.08, -0.95),
            child: Container(
              width: 5.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: widget!.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.74, 0.46),
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: widget!.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.7, -0.08),
            child: Container(
              width: 5.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: widget!.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
