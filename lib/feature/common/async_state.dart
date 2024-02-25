import 'package:freezed_annotation/freezed_annotation.dart';

@sealed
@immutable
abstract final class AsyncState<T> {
  const AsyncState._();
  const factory AsyncState.loading([Object value]) = AsyncStateLoading<T>;
  const factory AsyncState.data(T data) = AsyncStateData<T>;
  const factory AsyncState.error(Object error, [StackTrace stackTrace]) = AsyncStateError<T>;
  // const factory AsyncState.orElse() = AsyncStateOrElse<T>;

  T? get data;

  Object? get value;

  /// The [error].
  Object? get error;

  /// The stacktrace of [error].
  StackTrace? get stackTrace;

  bool get isLoading;

  bool get hasValue;
}

///
base class AsyncStateData<T> extends AsyncState<T> {
  const AsyncStateData(T data)
      : this._(
          data,
        );

  const AsyncStateData._(this.data) : super._();

  @override
  final T data;

  @override
  Object? get value => null;

  @override
  Object? get error => null;

  @override
  StackTrace? get stackTrace => null;

  @override
  bool get hasValue => true;

  @override
  // TODO: implement isLoading
  bool get isLoading => false;
}

///
base class AsyncStateLoading<T> extends AsyncState<T> {
  const AsyncStateLoading([Object? value])
      : this._(
          value,
        );

  const AsyncStateLoading._(this.value) : super._();

  @override
  T? get data => null;

  @override
  final Object? value;

  @override
  Object? get error => null;

  @override
  StackTrace? get stackTrace => null;

  @override
  bool get hasValue => false;

  @override
  bool get isLoading => true;
}

///
base class AsyncStateError<T> extends AsyncState<T> {
  const AsyncStateError(Object error, [StackTrace? stackTrace])
      : this._(
          error,
          stackTrace,
        );

  const AsyncStateError._(this.error, [this.stackTrace, this.data]) : super._();

  @override
  final T? data;

  @override
  Object? get value => null;

  @override
  final Object error;

  @override
  final StackTrace? stackTrace;

  @override
  bool get hasValue => false;

  @override
  bool get isLoading => false;
}

///
extension EAsyncState<T> on AsyncState<T> {
  R maybeWhen<R>({
    required R Function() orElse,
    R Function(T data)? data,
    R Function(Object error)? error,
    R Function([Object? value])? loading,
  }) {
    return when(
      data: data ?? (_) => orElse(),
      error: error ?? (err) => orElse(),
      loading: loading ?? ([Object? value]) => orElse(),
    );
  }

  bool get hasError => error != null;

  R when<R>({
    required R Function(T data) data,
    required R Function(Object error) error,
    required R Function([Object? value]) loading,
  }) {
    if (isLoading) {
      return loading(value);
    }

    if (hasError) {
      return error(this.error!);
    }

    return data(this.data as T);
  }
}
