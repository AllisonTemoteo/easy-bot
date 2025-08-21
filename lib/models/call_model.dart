class NpxCallModel {
  NpxCallModel({
    required this.callDateTime,
    required this.number,
    required this.agentCode,
  });

  final DateTime callDateTime;
  final String number;
  final String agentCode;

  factory NpxCallModel.fromMap(Map<String, Object?> map) {
    return NpxCallModel(
      callDateTime: DateTime.parse(map['calldatetime'] as String).toLocal(),
      number: map['src'] as String,
      agentCode: map['agent_code'] as String,
    );
  }

  String get id => _generateId();
  String get callDate => callDateTime.toIso8601String().split('T')[0];
  String get time => callDateTime.toIso8601String().split('T')[1];

  String _generateId() {
    var time = this.time.replaceAll(RegExp(r'\D'), '');
    return '$time $number';
  }

  @override
  String toString() {
    return '$runtimeType: {DataHora = $callDateTime, Telefone = $number}';
  }
}
