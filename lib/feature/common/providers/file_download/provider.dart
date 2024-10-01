import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/bootloader.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class DownloadBloc extends _$DownloadBloc {
  @override
  DownloadState build() {
    return const DownloadState();
  }
}
