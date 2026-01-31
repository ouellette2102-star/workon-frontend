/// Notifications screen for WorkOn.
///
/// **PR-REAL-01:** Replaced static mock data with honest empty state.
/// When backend notification API is ready, this will show real notifications.
import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'notifications_model.dart';
export 'notifications_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  static String routeName = 'Notifications';
  static String routePath = '/notifications';

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late NotificationsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    wrapWithModel(
                      model: _model.backIconBtnModel,
                      updateCallback: () => safeSetState(() {}),
                      child: BackIconBtnWidget(),
                    ),
                    Flexible(
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'abxdmrze' /* Notifications */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'General Sans',
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ].divide(SizedBox(width: 15.0)),
                ),
              ),
              FlutterFlowIconButton(
                borderRadius: 30.0,
                buttonSize: 40.0,
                icon: Icon(
                  FFIcons.ksetting,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed(NotificationSettingsWidget.routeName);
                },
              ),
            ].divide(SizedBox(width: 15.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Center(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Empty state icon
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 48.0,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  // Title
                  Text(
                    'Aucune notification',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'General Sans',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.0,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.0),
                  // Subtitle
                  Text(
                    'Vos notifications apparaîtront ici.\nActivez-les pour ne rien manquer !',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          lineHeight: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.0),
                  // Settings button
                  FFButtonWidget(
                    onPressed: () {
                      context.pushNamed(NotificationSettingsWidget.routeName);
                    },
                    text: 'Paramètres de notification',
                    options: FFButtonOptions(
                      height: 48.0,
                      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'General Sans',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
