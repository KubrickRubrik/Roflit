import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/middleware/zip_utils.dart';

final class BlocObserver extends ProviderObserver {
  final bool isUsed;
  BlocObserver({required this.isUsed});
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (isUsed) {
      logger.info('Provider $provider was initialized with $value');
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (isUsed) {
      logger.info('Provider $provider was disposed');
    }
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (isUsed) {
      logger.info('Provider $provider updated from $previousValue to $newValue');
    }
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (isUsed) {
      logger.error('Provider $provider threw $error at $stackTrace');
    }
  }
}
