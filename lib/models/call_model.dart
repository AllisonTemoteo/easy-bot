class NpxCallModel {
  const NpxCallModel({required this.callDateTime, required this.callerNumber});

  final DateTime callDateTime;
  final String callerNumber;

  factory NpxCallModel.fromMap(Map<String, Object?> map) {
    return NpxCallModel(
      callDateTime: DateTime.parse(map['calldatetime'] as String).toLocal(),
      callerNumber: map['src'] as String,
    );
  }

  String get callDateText => callDateTime.toIso8601String().split('T')[0];
  String get callTimeText => callDateTime.toIso8601String().split('T')[1];

  @override
  String toString() {
    return '$runtimeType: {DataHora = $callDateTime, Telefone = $callerNumber}';
  }
}
