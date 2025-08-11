import 'dart:convert';

import 'package:easy_bot/core/utils/env.dart';
import 'package:http/http.dart' as http;

enum ReportType {
  synthetic('synthetic'),
  analytic('analytic');

  final String value;
  const ReportType(this.value);
}

class NpxApiReportParams {
  const NpxApiReportParams({
    required this.reportType,
    required this.dateStartedAt,
    required this.dateEndingAt,
    this.queues = 'Proabakus_Suporte',
    this.filters,
  });

  final ReportType reportType;
  final String queues;
  final DateTime dateStartedAt;
  final DateTime dateEndingAt;
  final Map<String, Object>? filters;

  Map<String, Object> toMap() {
    return {
      'report_type': reportType.value,
      'queues': queues,
      'date_started_at': dateStartedAt.toIso8601String().split('T')[0],
      'date_ended_at': dateEndingAt.toIso8601String().split('T')[0],
      'time_started_at': dateStartedAt.toIso8601String().split('T')[1],
      'time_ended_at': dateEndingAt.toIso8601String().split('T')[1],

      ...filters ?? {},
    };
  }
}

class NpxApiClient {
  final _baseUrl = 'app.npxtech.com.br';

  Future<List<dynamic>?> getReport(NpxApiReportParams reportParams) async {
    final url = Uri.https(_baseUrl, 'api/v2/callcenter/report');

    final body = reportParams.toMap();

    var response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Access-token': Env.get('NPX_API_KEY'),
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    print('API error: ${response.body}');
    return null;
  }
}
