import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'invite_friend_item_model.dart';
export 'invite_friend_item_model.dart';

class InviteFriendItemWidget extends StatefulWidget {
  const InviteFriendItemWidget({
    super.key,
    required this.img,
  });

  final String? img;

  @override
  State<InviteFriendItemWidget> createState() => _InviteFriendItemWidgetState();
}

class _InviteFriendItemWidgetState extends State<InviteFriendItemWidget> {
  late InviteFriendItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InviteFriendItemModel());
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
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 58.0,
                      height: 58.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        widget!.img!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            'o5qvinzg' /* Lauralee Quintero */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            'qea0eg95' /* +1-234-555-890 */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'General Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                  ),
                ].divide(SizedBox(width: 15.0)),
              ),
            ),
            FFButtonWidget(
              onPressed: _model.isInvited
                  ? null
                  : () async {
                      _model.isInvited = !_model.isInvited;
                      _model.updatePage(() {});
                    },
              text: valueOrDefault<String>(
                _model.isInvited ? 'Invited' : 'Invite',
                'Invite',
              ),
              options: FFButtonOptions(
                height: 33.0,
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: _model.isInvited
                    ? Colors.transparent
                    : FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'General Sans',
                      color: _model.isInvited
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).info,
                      letterSpacing: 0.0,
                    ),
                elevation: 0.0,
                borderSide: BorderSide(
                  color: _model.isInvited
                      ? FlutterFlowTheme.of(context).primary
                      : Colors.transparent,
                  width: _model.isInvited ? 2.0 : 0.0,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ].divide(SizedBox(width: 20.0)),
        ),
      ),
    );
  }
}
