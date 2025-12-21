// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class MigSliderWidget extends StatefulWidget {
  const MigSliderWidget({
    super.key,
    this.width,
    this.height,
    this.initialValue,
    required this.minimum,
    required this.maximum,
    this.stepSize,
    required this.activeColor,
    required this.inactiveColor,
  });

  final double? width;
  final double? height;
  final double? initialValue;
  final double minimum;
  final double maximum;
  final double? stepSize;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<MigSliderWidget> createState() => _MigSliderWidgetState();
}

class _MigSliderWidgetState extends State<MigSliderWidget> {
  late RangeValues _currentRangeValues;
  double _minSelected = 0;
  double _maxSelected = 100;

  @override
  void initState() {
    super.initState();
    _minSelected = widget.minimum;
    _maxSelected = widget.maximum;
    _currentRangeValues = RangeValues(widget.minimum, widget.maximum);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 50,
      child: RangeSlider(
        values: _currentRangeValues,
        min: widget.minimum,
        max: widget.maximum,
        divisions: widget.stepSize != null
            ? ((widget.maximum - widget.minimum) / widget.stepSize!).round()
            : null,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        labels: RangeLabels(
          _currentRangeValues.start.toStringAsFixed(0),
          _currentRangeValues.end.toStringAsFixed(0),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            _currentRangeValues = values;
            _minSelected = values.start;
            _maxSelected = values.end;
          });

          // Update the page state variable in FlutterFlow
          FFAppState().update(() {
            FFAppState().migSliderValue = MigSliderValueStruct(
              minSelected: _minSelected,
              maxSelected: _maxSelected,
            );
          });
        },
      ),
    );
  }
}
