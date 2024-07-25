part of 'provider.dart';

@freezed
class BootloaderState with _$BootloaderState {
  const factory BootloaderState({
    @Default(BootloaderConfig()) BootloaderConfig config,
    @Default([]) List<BootloaderEntity> bootloaders,
  }) = _BootloaderState;
}

@freezed
class BootloaderConfig with _$BootloaderConfig {
  const factory BootloaderConfig({
    @Default(true) bool isOnUpload,
    @Default(true) bool isOnDownload,
    @Default(false) bool isActiveProccess,
    @Default(ActionFirst.upload) ActionFirst first,
  }) = _BootloaderConfig;

  const BootloaderConfig._();

  bool get isOn => isOnUpload || isOnDownload;
}
