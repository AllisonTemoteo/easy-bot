import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

class NpxApiClient {
  final baseUrl = 'app.npxtech.com.br';

  Future<List<dynamic>?> getReport(
    ReportType reportType,
    NpxApiReportParams filters,
  ) async {
    final env = DotEnv(includePlatformEnvironment: true)..load();

    final url = Uri.https(baseUrl, 'api/v2/callcenter/report');

    final body = {'report_type': reportType.value, ...filters.toMap()};

    var response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Access-token': env['NPX_API_KEY']!,
      },
    );

    return jsonDecode(response.body);
  }
}

enum ReportType {
  synthetic('synthetic'),
  analytic('analytic');

  final String value;
  const ReportType(this.value);
}

class NpxApiReportParams {
  const NpxApiReportParams({
    required this.dateStartedAt,
    required this.dateEndingAt,
    this.queues = 'Proabakus_Suporte',
    this.filters,
  });

  final String queues;
  final DateTime dateStartedAt;
  final DateTime dateEndingAt;
  final Map<String, Object>? filters;

  Map<String, Object> toMap() {
    return {
      'queues': queues,
      'date_started_at': dateStartedAt.toIso8601String().split('T')[0],
      'date_ended_at': dateEndingAt.toIso8601String().split('T')[0],
      'time_started_at': dateStartedAt.toIso8601String().split('T')[1],
      'time_ended_at': dateEndingAt.toIso8601String().split('T')[1],

      ...filters ?? {},
    };
  }
}
