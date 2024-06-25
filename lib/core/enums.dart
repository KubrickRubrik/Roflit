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
  loading,
  loaded,
  total,
  empty,
  error;

  bool get isError => this == error;
  bool get isEmpty => this == empty;
  bool get isLoading => this == loading;
  bool get isLoaded => this == loaded;
  bool get isTotal => this == total;

  const ContentStatus();
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
enum StorageType {
  yxCloud(title: 'Yandex Cloud'),
  vkCloud(title: 'VK Cloud');

  const StorageType({
    required this.title,
  });

  final String title;

  bool get isYandexCloud => this == yxCloud;
  bool get isVkCloud => this == vkCloud;

  StorageType fromTypeName(String? val) {
    return switch (val) {
      'yxCloud' => StorageType.yxCloud,
      _ => StorageType.vkCloud,
    };
  }
}

enum SessionType {
  guest,
  authorized;

  bool get isGuest => this == guest;
  bool get isAuthorized => this == authorized;

  const SessionType();
}

enum IconSourceType {
  bucket,
  image,
  doc,
  folder,
  archive,
  program,
  music,
  video,
  other;

  bool get isFolder => this == folder;
}

enum BucketCreateStatus {
  public,
  private;

  bool get isPublic => this == public;
  bool get isPrivate => this == private;
}
