import 'package:easy_bot/npx/models/call_model.dart';
import 'package:easy_bot/npx/repositories/npx_repository_api.dart';
import 'package:easy_bot/npx/services/npx_api_client.dart';

class NpxCommandsController {
  final bool monitoring = false;

  Future<List<NpxCallModel>?> startMonitoring() async {
    final client = NpxApiClient();
    final api = NpxRepositoryApi(client);

    final DateTime now = DateTime.now();

    return await api.getMissedCalls(
      Interval(
        dateTimeStarting: now.subtract(Duration(minutes: 5)),
        dateTimeEnding: now,
      ),
    );
  }
}
