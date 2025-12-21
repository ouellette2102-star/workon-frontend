import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'message_btn_model.dart';
export 'message_btn_model.dart';

class MessageBtnWidget extends StatefulWidget {
  const MessageBtnWidget({super.key});

  @override
  State<MessageBtnWidget> createState() => _MessageBtnWidgetState();
}

class _MessageBtnWidgetState extends State<MessageBtnWidget> {
  late MessageBtnModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessageBtnModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      child: Stack(
        children: [
          FlutterFlowIconButton(
            borderRadius: 14.0,
            buttonSize: 40.0,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            icon: Icon(
              FFIcons.kmessage28,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.pushNamed(MessagesWidget.routeName);
            },
          ),
          Align(
            alignment: AlignmentDirectional(1.0, -1.0),
            child: Material(
              color: Colors.transparent,
              elevation: 4.0,
              shape: const CircleBorder(),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 700),
                curve: Curves.bounceOut,
                width: 18.0,
                height: 18.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      'nslhvjva' /* 1 */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).info,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
