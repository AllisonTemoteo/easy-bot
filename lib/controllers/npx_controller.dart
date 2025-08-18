import 'dart:async';

import 'package:easy_bot/models/call_model.dart';
import 'package:easy_bot/repositories/npx_repository_api.dart';
import 'package:easy_bot/services/npx_api_client.dart';

class NpxController {
  NpxController._internal();
  static NpxController? _instance;
  static NpxController get instance => _instance ??= NpxController._internal();

  Map<String, NpxCallModel> missedCalls = {};

  Future<List<NpxCallModel>?> getNewMissedCalls() async {
    final client = NpxApiClient();
    final repository = NpxRepositoryApi(client);

    final now = DateTime.now().toLocal();

    final report = await repository.getMissedCalls(
      Interval(
        dateTimeStarting: now.subtract(Duration(minutes: 2)),
        dateTimeEnding: now,
      ),
    );

    List<NpxCallModel>? newMissedCalls;

    if (report != null) {
      newMissedCalls = [];
      for (var call in report) {
        if (missedCalls.containsKey(call.id)) {
          continue;
        }

        missedCalls[call.id] = call;
        newMissedCalls.add(call);
      }
    }

    return newMissedCalls;
  }
}
