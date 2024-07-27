import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/enums.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class SearchBloc extends _$SearchBloc {
  @override
  SearchState build() {
    return const SearchState();
  }

  void onSetBucketSource() {
    state = state.copyWith(source: SearchSource.bucket);
  }

  void onSetObjectSource() {
    state = state.copyWith(source: SearchSource.object);
  }

  void onChange(String value) {
    state = state.copyWith(search: value);
  }
}
