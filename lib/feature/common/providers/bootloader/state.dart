part of 'provider.dart';

@freezed
class BootloaderState with _$BootloaderState {
  const factory BootloaderState({
    @Default(AccountConfigEntity()) AccountConfigEntity config,
    @Default([]) List<BootloaderEntity> bootloaders,
    @Default(false) bool isActiveProccess,
  }) = _BootloaderState;
}
