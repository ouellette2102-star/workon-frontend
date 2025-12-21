import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'read_more_text_model.dart';
export 'read_more_text_model.dart';

class ReadMoreTextWidget extends StatefulWidget {
  const ReadMoreTextWidget({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  State<ReadMoreTextWidget> createState() => _ReadMoreTextWidgetState();
}

class _ReadMoreTextWidgetState extends State<ReadMoreTextWidget> {
  late ReadMoreTextModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReadMoreTextModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      text: TextSpan(
        children: [
          TextSpan(
            text: valueOrDefault<String>(
              _model.viewMore
                  ? widget!.text
                  : ((String text) {
                      return text.length > 120
                          ? text.substring(0, 120) + "..."
                          : text;
                    }(widget!.text!)),
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce feugiat odio eget elit bibendum, eu semper ligula fringilla...',
            ),
            style: TextStyle(),
          ),
          TextSpan(
            text: (String var1) {
              return var1.length > 120 ? true : false;
            }(widget!.text!)
                ? (_model.viewMore ? 'view less' : 'view more')
                : ' ',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primary,
              fontWeight: FontWeight.bold,
            ),
            mouseCursor: SystemMouseCursors.click,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                _model.viewMore = !_model.viewMore;
                _model.updatePage(() {});
              },
          )
        ],
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'General Sans',
              fontSize: 14.0,
              letterSpacing: 0.0,
              lineHeight: 1.5,
            ),
      ),
    );
  }
}
