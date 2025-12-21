import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  MigSliderValueStruct _migSliderValue = MigSliderValueStruct();
  MigSliderValueStruct get migSliderValue => _migSliderValue;
  set migSliderValue(MigSliderValueStruct value) {
    _migSliderValue = value;
  }

  void updateMigSliderValueStruct(Function(MigSliderValueStruct) updateFn) {
    updateFn(_migSliderValue);
  }

  String _OnScreenKeyboardValue = '0';
  String get OnScreenKeyboardValue => _OnScreenKeyboardValue;
  set OnScreenKeyboardValue(String value) {
    _OnScreenKeyboardValue = value;
  }

  LineChartDataStruct _LineChartData = LineChartDataStruct.fromSerializableMap(
      jsonDecode(
          '{\"yData\":\"[\\\"130\\\",\\\"260\\\",\\\"300\\\",\\\"140\\\",\\\"490\\\"]\",\"xData\":\"[\\\"100\\\",\\\"200\\\",\\\"300\\\",\\\"400\\\",\\\"500\\\"]\"}'));
  LineChartDataStruct get LineChartData => _LineChartData;
  set LineChartData(LineChartDataStruct value) {
    _LineChartData = value;
  }

  void updateLineChartDataStruct(Function(LineChartDataStruct) updateFn) {
    updateFn(_LineChartData);
  }
}
