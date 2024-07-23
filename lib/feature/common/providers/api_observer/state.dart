part of 'provider.dart';

@freezed
class ApiObserverState with _$ApiObserverState {
  const factory ApiObserverState({
    @Default(null) ApiObjectObserver? upload,
    @Default(null) ApiObjectObserver? download,
  }) = _ApiObserverState;
}

@freezed
class ApiObjectObserver with _$ApiObjectObserver {
  const factory ApiObjectObserver({
    required int idBootloader,
    required ApiObjectValue observe,
  }) = _ApiObjectObserver;

  factory ApiObjectObserver.addObserve({
    required int idBootloader,
  }) {
    return ApiObjectObserver(
      idBootloader: idBootloader,
      observe: ApiObjectValue.empty(),
    );
  }
  // factory ApiObjectObserver.addObserve(int idBootloader) {
  // return ApiObjectObserver(
  //   idBootloader: idBootloader,
  //   observe: ApiObjectValue.empty(),
  // );
  // }
}

final class ApiObjectValue {
  final int count;
  final int total;

  ApiObjectValue({required this.count, required this.total});

  factory ApiObjectValue.empty() {
    return ApiObjectValue(count: 0, total: 0);
  }

  int get percentage {
    if (total == 0) return 0;
    return (count * 100) ~/ total;
  }
}
