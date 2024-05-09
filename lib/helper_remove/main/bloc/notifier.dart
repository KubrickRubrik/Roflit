import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.freezed.dart';
part 'notifier.g.dart';
part 'state.dart';

@riverpod
final class MainNotifier extends _$MainNotifier {
  // late final _apiClientService = ref.read(apiRemoteBucketsServiceProvider);

  @override
  MainState build() {
    // ref.listenSelf((previous, next) {
    // if (next.counter == 2) {
    //   ref.read(testNotifierProvider.notifier).actionPlus();
    // }
    // });
    // print('>>>> update MainNotifier');
    // return const MainState.loading();
    return const MainState.loaded();
  }

  Future<void> getData() async {
    // state = const MainState.loading();

    // final response = await _apiClientService.getBuckets();
    // state = MainState.loaded(buckets: response, selectedBucket: 0);
  }

  Future<void> getBucketObjects(int index) async {
    // final newState = state as MainLoadedState;
    // final list = newState.buckets.toList();
    // final bucket = list[index].copyWith(
    //   loading: true,
    //   objects: [],
    // );

    // list[index] = bucket;
    // state = newState.copyWith(buckets: list, selectedBucket: index);

    // final bucketName = newState.buckets[index].name;
    // final response = await _apiClientService.getBucketObjects(bucketName: bucketName);

    // final newBucket = list[index].copyWith(loading: false, objects: response);
    // list[index] = newBucket;

    // state = (state as MainLoadedState).copyWith(buckets: list);
  }
}
