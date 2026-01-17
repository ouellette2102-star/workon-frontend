import '/components/coming_soon_screen.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/provider_part/components_provider/job_item_menu/job_item_menu_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'job_item_in_progress_model.dart';
export 'job_item_in_progress_model.dart';

class JobItemInProgressWidget extends StatefulWidget {
  const JobItemInProgressWidget({
    super.key,
    required this.img,
    required this.title,
  });

  final String? img;
  final String? title;

  @override
  State<JobItemInProgressWidget> createState() =>
      _JobItemInProgressWidgetState();
}

class _JobItemInProgressWidgetState extends State<JobItemInProgressWidget> {
  late JobItemInProgressModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JobItemInProgressModel());
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
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(JobDetailsWidget.routeName);
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: Image.network(
                          widget!.img!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget!.title,
                            'Laundry Services & 3 more',
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(),
                                    child: LinearPercentIndicator(
                                      percent: 0.75,
                                      lineHeight: 7.0,
                                      animation: true,
                                      animateFromLastPercent: true,
                                      progressColor:
                                          FlutterFlowTheme.of(context).success,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).accent4,
                                      barRadius: Radius.circular(30.0),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FFIcons.ktickCircle56,
                                      color:
                                          FlutterFlowTheme.of(context).success,
                                      size: 16.0,
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'u8crvsm2' /* 75% Almost done */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'General Sans',
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ].divide(SizedBox(width: 5.0)),
                                ),
                              ].divide(SizedBox(height: 10.0)),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 10.0)),
                    ),
                  ),
                ].divide(SizedBox(width: 15.0)),
              ),
            ),
            Divider(
              height: 1.0,
              color: FlutterFlowTheme.of(context).alternate,
            ),
            // PR-15: Replace dead-end routes with coming soon
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () async {
                      showComingSoon(context, 'Reprogrammation');
                    },
                    text: FFLocalizations.of(context).getText(
                      'kpsvg59a' /* Reschedule */,
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'General Sans',
                                color: FlutterFlowTheme.of(context).info,
                                letterSpacing: 0.0,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).alternate,
                  borderRadius: 30.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    FFIcons.kmessage21,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 22.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(ChatWidget.routeName);
                  },
                ),
                FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).alternate,
                  borderRadius: 30.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    FFIcons.kcall,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 22.0,
                  ),
                  onPressed: () async {
                    showComingSoon(context, 'Appels vocaux');
                  },
                ),
                FlutterFlowIconButton(
                  borderRadius: 30.0,
                  buttonSize: 40.0,
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  icon: Icon(
                    Icons.more_vert_sharp,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 22.0,
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: JobItemMenuWidget(
                            bookingStatus: 'pending',
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                ),
              ].divide(SizedBox(width: 10.0)),
            ),
          ].divide(SizedBox(height: 10.0)),
        ),
      ),
    );
  }
}
