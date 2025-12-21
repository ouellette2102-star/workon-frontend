// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LineChartDataStruct extends BaseStruct {
  LineChartDataStruct({
    List<double>? yData,
    List<double>? xData,
  })  : _yData = yData,
        _xData = xData;

  // "yData" field.
  List<double>? _yData;
  List<double> get yData => _yData ?? const [];
  set yData(List<double>? val) => _yData = val;

  void updateYData(Function(List<double>) updateFn) {
    updateFn(_yData ??= []);
  }

  bool hasYData() => _yData != null;

  // "xData" field.
  List<double>? _xData;
  List<double> get xData => _xData ?? const [];
  set xData(List<double>? val) => _xData = val;

  void updateXData(Function(List<double>) updateFn) {
    updateFn(_xData ??= []);
  }

  bool hasXData() => _xData != null;

  static LineChartDataStruct fromMap(Map<String, dynamic> data) =>
      LineChartDataStruct(
        yData: getDataList(data['yData']),
        xData: getDataList(data['xData']),
      );

  static LineChartDataStruct? maybeFromMap(dynamic data) => data is Map
      ? LineChartDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'yData': _yData,
        'xData': _xData,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'yData': serializeParam(
          _yData,
          ParamType.double,
          isList: true,
        ),
        'xData': serializeParam(
          _xData,
          ParamType.double,
          isList: true,
        ),
      }.withoutNulls;

  static LineChartDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      LineChartDataStruct(
        yData: deserializeParam<double>(
          data['yData'],
          ParamType.double,
          true,
        ),
        xData: deserializeParam<double>(
          data['xData'],
          ParamType.double,
          true,
        ),
      );

  @override
  String toString() => 'LineChartDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is LineChartDataStruct &&
        listEquality.equals(yData, other.yData) &&
        listEquality.equals(xData, other.xData);
  }

  @override
  int get hashCode => const ListEquality().hash([yData, xData]);
}

LineChartDataStruct createLineChartDataStruct() => LineChartDataStruct();
