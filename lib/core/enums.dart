import 'dart:ui';

/// Session state of the application/user.
enum AppSessionState { isNotAuth, isAuth }

/// Available interface themes for selection in the application.
enum AvailableAppTheme { light, dark }

/// Available languages for selection in the app.
enum AppLocalization {
  ru(title: 'Русский', locale: Locale('ru', 'RU')),
  en(title: 'English', locale: Locale('en', 'US'));

  const AppLocalization({
    required this.title,
    required this.locale,
  });

  final String title;
  final Locale locale;

  // AppLocalization fromName(String? val) {
  //   return switch (val) {
  //     'en' => AppLocalization.en,
  //     _ => AppLocalization.ru,
  //   };
  // }
}

/// Activity activity status.
enum ActionStatus { isAction, isDone }

/// Content loading status.
enum ContentStatus {
  isLoadContent,
  isNoContent,
  isErrorContent,
  isEmptyContent,
  isDisplayContent,
}

/// Section loading status.
enum SectionStatus {
  isLoadContent,
  isNoContent,
  isDisplayContent,
}

/// News viewing status.
enum DisplayStatus {
  isNotDisplayed,
  isDisplayed,
}

/// Type of toast.
enum TypeMassage { good, massage, error, warning }

/// Type of cloud
enum TypeStorage {
  yxCloud(title: 'Yandex Cloud'),
  vkCloud(title: 'VK Cloud');

  const TypeStorage({
    required this.title,
  });

  final String title;

  bool get isYandexCloud => this == yxCloud;
  bool get isVkCloud => this == vkCloud;

  // TypeStorage fromName(String? val) {
  //   return switch (val) {
  //     'yandexCloud' => TypeStorage.yxCloud,
  //     'vkCloud' => TypeStorage.vkCloud,
  //     _ => TypeStorage.none,
  //   };
  // }
}

enum SessionType {
  guest,
  authorized;

  bool get isGuest => this == guest;
  bool get isAuthorized => this == authorized;

  const SessionType();
}
