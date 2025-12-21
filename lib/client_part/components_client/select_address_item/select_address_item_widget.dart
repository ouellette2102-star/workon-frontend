import '/client_part/components_client/radio_btn/radio_btn_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'select_address_item_model.dart';
export 'select_address_item_model.dart';

class SelectAddressItemWidget extends StatefulWidget {
  const SelectAddressItemWidget({
    super.key,
    required this.isDefault,
  });

  final bool? isDefault;

  @override
  State<SelectAddressItemWidget> createState() =>
      _SelectAddressItemWidgetState();
}

class _SelectAddressItemWidgetState extends State<SelectAddressItemWidget> {
  late SelectAddressItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectAddressItemModel());
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
        border: Border.all(
          color: _model.radioBtnModel.isChecked
              ? FlutterFlowTheme.of(context).primary
              : Colors.transparent,
          width: _model.radioBtnModel.isChecked ? 2.0 : 0.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10.0, 15.0, 10.0, 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 55.0,
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FFIcons.klocation08,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'sje77vnq' /* Home */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'General Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            if (widget!.isDefault ?? true)
                              Container(
                                height: 22.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        6.0, 2.0, 6.0, 3.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'huz5soow' /* Default */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'General Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            fontSize: 10.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                          ].divide(SizedBox(width: 15.0)),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            'u522nen9' /* KK 486 ST, Kicukiro, Kigali, R... */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'General Sans',
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ].divide(SizedBox(height: 5.0)),
                    ),
                  ),
                ].divide(SizedBox(width: 15.0)),
              ),
            ),
            wrapWithModel(
              model: _model.radioBtnModel,
              updateCallback: () => safeSetState(() {}),
              child: RadioBtnWidget(),
            ),
          ].divide(SizedBox(width: 15.0)),
        ),
      ),
    );
  }
}
