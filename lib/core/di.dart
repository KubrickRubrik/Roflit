import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/data/api_local_client.dart';
import 'package:roflit/data/api_remote_client.dart';

part 'di.g.dart';

@Riverpod()
DiService di(DiRef ref) {
  return DiService(ref);
}

final class DiService {
  final ApiRemoteClient apiRemoteClient;
  final ApiLocalClient apiLocalClient;
  DiService(DiRef ref)
      : apiRemoteClient = ref.read(apiRemoteClientProvider),
        apiLocalClient = ref.read(apiLocalClientProvider) {
    ref.onCancel(_cansel);
  }

  Future<void> _cansel() async {
    await apiLocalClient.closeDb();
  }
}
