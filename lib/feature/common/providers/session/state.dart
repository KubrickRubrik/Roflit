part of 'provider.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState.init() = SessionInitState;

  const factory SessionState.loading() = SessionLoadingState;

  const factory SessionState.loaded({
    @Default(SessionEntity()) SessionEntity session,
    @Default([]) List<AccountEntity> accounts,
  }) = SessionLoadedState;
}
