import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/data/remote/api_remote_buckets_service.dart';

part 'di.g.dart';

@riverpod
DiService di(DiRef ref) {
  return DiService(ref);
}

final class DiService {
  final ApiRemoteBucketsService apiRemoteBucketService;
  DiService(DiRef ref) : apiRemoteBucketService = ref.read(apiRemoteBucketsServiceProvider);
}
