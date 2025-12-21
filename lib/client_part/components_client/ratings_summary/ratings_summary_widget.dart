import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'ratings_summary_model.dart';
export 'ratings_summary_model.dart';

class RatingsSummaryWidget extends StatefulWidget {
  const RatingsSummaryWidget({super.key});

  @override
  State<RatingsSummaryWidget> createState() => _RatingsSummaryWidgetState();
}

class _RatingsSummaryWidgetState extends State<RatingsSummaryWidget> {
  late RatingsSummaryModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RatingsSummaryModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                FFLocalizations.of(context).getText(
                  't8f2ow8j' /* 4.8 */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      fontSize: 40.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              RatingBarIndicator(
                itemBuilder: (context, index) => Icon(
                  Icons.star_rounded,
                  color: FlutterFlowTheme.of(context).tertiary,
                ),
                direction: Axis.horizontal,
                rating: 4.5,
                unratedColor: FlutterFlowTheme.of(context).accent3,
                itemCount: 5,
                itemSize: 30.0,
              ),
              Text(
                FFLocalizations.of(context).getText(
                  '4py3id5t' /* 986 reviews */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'General Sans',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ].divide(SizedBox(height: 10.0)),
          ),
        ),
        SizedBox(
          height: 120.0,
          child: VerticalDivider(
            width: 1.0,
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'chv2rid3' /* 5 */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        percent: 0.95,
                        lineHeight: 6.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).tertiary,
                        backgroundColor: FlutterFlowTheme.of(context).alternate,
                        barRadius: Radius.circular(20.0),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ].divide(SizedBox(width: 10.0)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'f91npoeo' /* 4 */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        percent: 0.87,
                        lineHeight: 6.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).tertiary,
                        backgroundColor: FlutterFlowTheme.of(context).alternate,
                        barRadius: Radius.circular(20.0),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ].divide(SizedBox(width: 10.0)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'ubt2vqxm' /* 3 */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        percent: 0.3,
                        lineHeight: 6.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).tertiary,
                        backgroundColor: FlutterFlowTheme.of(context).alternate,
                        barRadius: Radius.circular(20.0),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ].divide(SizedBox(width: 10.0)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        '56r8n2c0' /* 2 */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        percent: 0.6,
                        lineHeight: 6.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).tertiary,
                        backgroundColor: FlutterFlowTheme.of(context).alternate,
                        barRadius: Radius.circular(20.0),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ].divide(SizedBox(width: 10.0)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'agpqgcts' /* 1 */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        percent: 0.1,
                        lineHeight: 6.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).tertiary,
                        backgroundColor: FlutterFlowTheme.of(context).alternate,
                        barRadius: Radius.circular(20.0),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ].divide(SizedBox(width: 10.0)),
                ),
              ].divide(SizedBox(height: 10.0)),
            ),
          ),
        ),
      ].divide(SizedBox(width: 15.0)),
    );
  }
}
