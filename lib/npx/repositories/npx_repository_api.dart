import 'package:easy_bot/npx/models/call_model.dart';
import 'package:easy_bot/npx/services/npx_api_client.dart';

abstract interface class INpxRepositoryApi {
  Future<List<NpxCallModel>?> getMissedCalls(Interval interval);
}

class Interval {
  const Interval({
    required this.dateTimeStarting,
    required this.dateTimeEnding,
  });

  final DateTime dateTimeStarting;
  final DateTime dateTimeEnding;
}

class NpxRepositoryApi implements INpxRepositoryApi {
  NpxRepositoryApi(NpxApiClient client) : _client = client;
  final NpxApiClient _client;

  @override
  Future<List<NpxCallModel>?> getMissedCalls(Interval interval) async {
    final NpxApiReportParams params = NpxApiReportParams(
      reportType: ReportType.analytic,
      dateStartedAt: interval.dateTimeStarting,
      dateEndingAt: interval.dateTimeEnding,
      filters: {'status': 'NOT ANSWERED', 'hangupcause': -1},
    );

    final report = await _client.getReport(params);

    if (report != null && report.isNotEmpty) {
      return report.map((call) => NpxCallModel.fromMap(call)).toList();
    }

    return null;
  }
}
