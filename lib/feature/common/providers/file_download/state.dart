part of 'provider.dart';

@freezed
class DownloadState with _$DownloadState {
  const factory DownloadState({
    @Default([]) List<BootloaderEntity> items,
  }) = _DownloadState;
}
