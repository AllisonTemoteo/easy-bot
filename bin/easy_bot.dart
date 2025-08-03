import 'package:easy_bot/bot_config.dart';
// import 'package:easy_bot/npx/repositories/npx_repository_api.dart';
// import 'package:easy_bot/npx/services/npx_api_client.dart';

// void main() async {
//   final NpxApiClient client = NpxApiClient();
//   final INpxRepositoryApi api = NpxRepositoryApi(client);

//   print(
//     await api.getMissedCalls(
//       Interval(
//         dateTimeStarting: DateTime.parse('2025-08-01 00:00:00'),
//         dateTimeEnding: DateTime.parse('2025-08-01 23:59:59'),
//       ),
//     ),
//   );
// }

void main() async {
  final bot = EasyBot();
  bot.start();
}
