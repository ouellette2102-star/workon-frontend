import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/ratings_summary/ratings_summary_widget.dart';
import '/client_part/components_client/review_item/review_item_widget.dart';
import '/client_part/components_client/search_btn/search_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'all_reviews_model.dart';
export 'all_reviews_model.dart';

class AllReviewsWidget extends StatefulWidget {
  const AllReviewsWidget({super.key});

  static String routeName = 'AllReviews';
  static String routePath = '/allReviews';

  @override
  State<AllReviewsWidget> createState() => _AllReviewsWidgetState();
}

class _AllReviewsWidgetState extends State<AllReviewsWidget> {
  late AllReviewsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AllReviewsModel());
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
                          '4zq2za2n' /* All Reviews */,
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
              wrapWithModel(
                model: _model.searchBtnModel,
                updateCallback: () => safeSetState(() {}),
                child: SearchBtnWidget(),
              ),
            ].divide(SizedBox(width: 15.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  wrapWithModel(
                    model: _model.ratingsSummaryModel,
                    updateCallback: () => safeSetState(() {}),
                    child: RatingsSummaryWidget(),
                  ),
                  Divider(
                    height: 1.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  Wrap(
                    spacing: 0.0,
                    runSpacing: 20.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      wrapWithModel(
                        model: _model.reviewItemModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1688350808212-4e6908a03925?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHwwfDB8fHww',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.reviewItemModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1722859288966-b00ef70df64b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.reviewItemModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1638727295415-286409421143?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.reviewItemModel4,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1499651681375-8afc5a4db253?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjZ8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.reviewItemModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: ReviewItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1689977807477-a579eda91fa2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDF8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                    ],
                  ),
                ]
                    .divide(SizedBox(height: 20.0))
                    .addToStart(SizedBox(height: 20.0))
                    .addToEnd(SizedBox(height: 20.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
