class NpxCallModel {
  NpxCallModel({required this.callDateTime, required this.callerNumber});

  final DateTime callDateTime;
  final String callerNumber;

  factory NpxCallModel.fromMap(Map<String, Object?> map) {
    return NpxCallModel(
      callDateTime: DateTime.parse(map['calldatetime'] as String).toLocal(),
      callerNumber: map['src'] as String,
    );
  }

  String get id => callTime + callerNumber;
  String get callDateText => callDateTime.toIso8601String().split('T')[0];
  String get callTime => callDateTime.toIso8601String().split('T')[1];

  @override
  String toString() {
    return '$runtimeType: {DataHora = $callDateTime, Telefone = $callerNumber}';
  }
}
