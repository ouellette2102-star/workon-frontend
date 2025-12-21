// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MigSliderValueStruct extends BaseStruct {
  MigSliderValueStruct({
    double? minSelected,
    double? maxSelected,
  })  : _minSelected = minSelected,
        _maxSelected = maxSelected;

  // "minSelected" field.
  double? _minSelected;
  double get minSelected => _minSelected ?? 0.0;
  set minSelected(double? val) => _minSelected = val;

  void incrementMinSelected(double amount) =>
      minSelected = minSelected + amount;

  bool hasMinSelected() => _minSelected != null;

  // "maxSelected" field.
  double? _maxSelected;
  double get maxSelected => _maxSelected ?? 0.0;
  set maxSelected(double? val) => _maxSelected = val;

  void incrementMaxSelected(double amount) =>
      maxSelected = maxSelected + amount;

  bool hasMaxSelected() => _maxSelected != null;

  static MigSliderValueStruct fromMap(Map<String, dynamic> data) =>
      MigSliderValueStruct(
        minSelected: castToType<double>(data['minSelected']),
        maxSelected: castToType<double>(data['maxSelected']),
      );

  static MigSliderValueStruct? maybeFromMap(dynamic data) => data is Map
      ? MigSliderValueStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'minSelected': _minSelected,
        'maxSelected': _maxSelected,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'minSelected': serializeParam(
          _minSelected,
          ParamType.double,
        ),
        'maxSelected': serializeParam(
          _maxSelected,
          ParamType.double,
        ),
      }.withoutNulls;

  static MigSliderValueStruct fromSerializableMap(Map<String, dynamic> data) =>
      MigSliderValueStruct(
        minSelected: deserializeParam(
          data['minSelected'],
          ParamType.double,
          false,
        ),
        maxSelected: deserializeParam(
          data['maxSelected'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'MigSliderValueStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MigSliderValueStruct &&
        minSelected == other.minSelected &&
        maxSelected == other.maxSelected;
  }

  @override
  int get hashCode => const ListEquality().hash([minSelected, maxSelected]);
}

MigSliderValueStruct createMigSliderValueStruct({
  double? minSelected,
  double? maxSelected,
}) =>
    MigSliderValueStruct(
      minSelected: minSelected,
      maxSelected: maxSelected,
    );
