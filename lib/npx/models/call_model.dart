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

  @override
  String toString() {
    return '$runtimeType: {DataHora = $callDateTime, Telefone = $callerNumber}';
  }
}
