part of 'provider.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    @Default(SearchSource.bucket) SearchSource source,
    @Default(null) String? search,
  }) = _SearchState;
}
