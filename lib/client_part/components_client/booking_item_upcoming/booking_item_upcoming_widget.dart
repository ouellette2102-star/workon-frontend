import '/client_part/components_client/confirmation_bookings_b_s/confirmation_bookings_b_s_widget.dart';
import '/client_part/components_client/menu_booking_item/menu_booking_item_widget.dart';
import '/components/coming_soon_screen.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'booking_item_upcoming_model.dart';
export 'booking_item_upcoming_model.dart';

class BookingItemUpcomingWidget extends StatefulWidget {
  const BookingItemUpcomingWidget({
    super.key,
    required this.img,
    required this.title,
  });

  final String? img;
  final String? title;

  @override
  State<BookingItemUpcomingWidget> createState() =>
      _BookingItemUpcomingWidgetState();
}

class _BookingItemUpcomingWidgetState extends State<BookingItemUpcomingWidget> {
  late BookingItemUpcomingModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BookingItemUpcomingModel());
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
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(BookingDetailsWidget.routeName);
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
                            'Bedroom Cleaning',
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
                            'wdaxn8wp' /* +2 other services */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            '5xoffz5k' /* Today 22 Dec, 2025 | 11:00 AM */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
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
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        useSafeArea: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: ConfirmationBookingsBSWidget(
                              title: FFLocalizations.of(context).getText(
                                'iqsp03zd' /* Are you sure you want to cance... */,
                              ),
                              img: widget!.img!,
                              primaryBtnText:
                                  FFLocalizations.of(context).getText(
                                'lc4vqrjd' /* Yes, Cancel */,
                              ),
                              secondaryBtnText:
                                  FFLocalizations.of(context).getText(
                                '90zf8wyw' /* Back */,
                              ),
                              // PR-15: CancelBooking is template-only
                              primaryBtnAction: () async {
                                Navigator.pop(context);
                                showComingSoon(context, 'Annulation');
                              },
                              secondaryBtnAction: () async {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                    text: FFLocalizations.of(context).getText(
                      '05igkg3c' /* Cancel */,
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).error,
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
                // PR-15: VoiceCall is template-only
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
                          child: MenuBookingItemWidget(
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
