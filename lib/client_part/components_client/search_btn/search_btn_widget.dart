import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'search_btn_model.dart';
export 'search_btn_model.dart';

class SearchBtnWidget extends StatefulWidget {
  const SearchBtnWidget({super.key});

  @override
  State<SearchBtnWidget> createState() => _SearchBtnWidgetState();
}

class _SearchBtnWidgetState extends State<SearchBtnWidget> {
  late SearchBtnModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchBtnModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFlowIconButton(
      borderRadius: 30.0,
      buttonSize: 40.0,
      icon: Icon(
        FFIcons.ksearchNormal01,
        color: FlutterFlowTheme.of(context).primaryText,
        size: 22.0,
      ),
      onPressed: () async {
        context.pushNamed(SearchWidget.routeName);
      },
    );
  }
}
